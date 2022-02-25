const {createTransactionForUser, generateTimestamp} = require("../utils");
const {getFirestore} = require("firebase-admin/firestore");
const db = getFirestore();

let placeOrder = async (req) => {
    let user = await (await db.collection('users').doc(`${req.user.uid}`).get()).data();
    //On crée un objet vide qui sera la réponse retournée
    const response = {};
    const solde = await getBalance(req);
    const open = await isOpen();
    if (!open) return "CLOSED";
    response.user_id = req.user.uid;
    //Calcul du total de la commande depuis la BDD
    let total = 0;
    await Promise.all(req.body.items.map(async (product) => {
        total += Math.max(product['qte'], 0) * (await (await db.collection('products').doc(`${product['product_id']}`).get()).data())['price'];
    }));
    response.total = total;
    if (response.total > solde) return "NOT_ENOUGH_FUNDS";
    if (response.total <= 0) return "MONEY_LESS_THAN_ZERO";
    //Enregistrement de la transaction dans la BDD. On considère que la transaction est valide
    await createTransactionForUser(req.user, -(response.total), "BILLING", "PRODUCTS");
    response.timestamp = generateTimestamp()
    //On crée la commande dans la BDD
    await db.collection('orders').add({
        user_id: req.user.uid,
        items: req.body.items.filter(item => item["qte"] > 0),
        total: response.total,
        status: "PENDING",
        timestamp: response.timestamp
    });
    //On ajoute le montant au solde de l'utilisateur
    user.balance = parseFloat((user.balance - response.total).toFixed(2));
    //On met à jour l'utilisateur dans la BDD
    await db.collection('users').doc(`${req.user.uid}`).set(user);
    //On envoie la réponse
    //TODO NOTIFIER BACKOFFICE
    return response;
}

let addFunds = async (req) => {
    //On récupère le montant passé dans la requête
    const amount = parseFloat(req.body.amount);
    //On récupère l'utilisateur depuis firestore
    let user = await (await db.collection('users').doc(`${req.user.uid}`).get()).data();
    //On effectue des verifications
    if (!amount || isNaN(amount) || amount < 5 || amount > 200 || user.balance + amount > 200) return false;
    await createTransactionForUser(req.user, amount, "TRANSFER", "ADD");
    //On ajoute le montant au solde de l'utilisateur
    user.balance = parseFloat((user.balance + amount).toFixed(2));
    //On met à jour l'utilisateur dans la BDD
    await db.collection('users').doc(`${req.user.uid}`).set(user);
    //On retourne le solde
    return user.balance
}

let removeFunds = async (req) => {
    //On récupère le montant passé dans la requête
    const amount = parseFloat(req.body.amount);
    //On récupère l'utilisateur depuis firestore
    let user = await (await db.collection('users').doc(`${req.user.uid}`).get()).data();
    //On effectue des verifications
    if (!amount || isNaN(amount) || amount <= 0) return false;
    if (user.balance - amount < 0) return "NEF";
    await createTransactionForUser(req.user, -(amount), "TRANSFER", "REMOVE");
    //On ajoute le montant au solde de l'utilisateur
    user.balance = parseFloat((user.balance - amount).toFixed(2));
    //On met à jour l'utilisateur dans la BDD
    await db.collection('users').doc(`${req.user.uid}`).set(user);
    return user.balance;
}

let getBalance = async (req) => {
    //On récupère l'utilisateur depuis firestore
    let user = await (await db.collection('users').doc(`${req.user.uid}`).get()).data();
    //On retourne le solde
    return user['balance'];
}

let getOrders = async (req) => {
    //On récupère toutes les commandes ayant l'uid de l'utilisateur
    const data = [];
    const orderCollections = db.collection('orders')
    const snapshot = await orderCollections.where('user_id', '==', `${req.user.uid}`).get();
    if (snapshot.empty) return false;
    for (let doc of snapshot.docs) {
        const order = doc.data();
        order.items = [];
        order.user_id = undefined;
        for (let item of (await orderCollections.doc(`${doc.id}`).collection('items').get()).docs) {
            order.items.push(item.data())
        }
        data.push(doc.id, order)
    }
    return data;
}

let getTransactions = async (req) => {
    const data = []
    //On récupère toutes les transactions de l'utilisateur
    const snapshot = await db.collection('users').doc(`${req.user.uid}`).collection('transactions').limit(req.query.limit ? parseInt(req.query.limit) : 0).get();
    //Si aucune transaction n'a été trouvée, on retourne false
    if (snapshot.empty) return false;
    for (let doc of snapshot.docs) {
        data.push(doc.data())
    }
    return data
}

let getProducts = async (category) => {
    const data = [];
    let snapshot;
    //On récupère toutes les transactions de l'utilisateur
    if (category != null && category !== "")
        snapshot = await db.collection('products').where('category', '=', category).get();
    else
        snapshot = await db.collection('products').get();
    //Si aucune transaction n'a été trouvée, on retourne false
    if (snapshot.empty) return false;
    for (let doc of snapshot.docs) {
        data.push(doc.data())
    }
    return data;
}

let isOpen = async () => {
    //On récupère une variable en BDD
    const snapshot = await db.collection('global_data').doc('charlemiam').get();
    if (snapshot['empty']) return false; else return (snapshot.data()['is_open'] === true) ?? false;
}

let setOpening = async (req) => {
    const open = req.body['opened'] === "true" ?? false;
    const document = await db.collection('global_data').doc('charlemiam');
    if ((await document.get)["empty"]) await document.set({is_open: open});
    await document.update({
        is_open: open
    });
    return true;
}

let getCategories = async () => {
    const data = [];
    const tmp = ["Sandwichs", "Viennoiseries", "Boissons", "Plats Chauds", "Petite Faim", "Desserts"];
    //On récupère toutes les categories de produits
    const snapshot = await db.collection('products').get();
    //Si aucune categorie n'a été trouvée, on retourne false
    if (snapshot.empty) return false;
    for (let doc of snapshot.docs) {
        const category = doc.data()["category"];
        if (!data.includes(category)) data.push(category);
    }
    data.sort((a, b) => tmp.includes(a) && tmp.includes(b) ? tmp.indexOf(a) - tmp.indexOf(b) : tmp.length + 1);
    return data;
}

module.exports = {
    placeOrder,
    addFunds,
    removeFunds,
    getBalance,
    getOrders,
    getTransactions,
    getProducts,
    isOpen,
    setOpening,
    getCategories
}
