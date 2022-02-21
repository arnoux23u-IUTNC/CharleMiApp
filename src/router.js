const router = require('express').Router();
const authMiddleware = require('./middleware/auth');
const {getFirestore} = require("firebase-admin/firestore");
const {createTransactionForUser} = require("./utils");

const db = getFirestore();

//Route correspondant à la création d'une commande (/api/place-order/)
router.post('/place-order', authMiddleware, async (req, res) => {
    try {
        //let user = await (await db.collection('users').doc(`${req.user.uid}`).get()).data();
        //TODO ICI EFFECTUER LES MUTLIPLES VERIFICATIONS LIEES AU PASSAGE D'UNE COMMANDE (SOLDE, HORAIRES...)
        //On crée un objet vide qui sera la réponse retournée
        const response = {};
        response.user_id = req.user.uid;
        //Calcul du total de la commande depuis la BDD
        let total = 0;
        let prices = await Promise.all(req.body.items.map(async (product) => total += Math.max(product['qte'], 0) * (await (await db.collection('products').doc(`${product['product_id']}`).get()).data())['price']));
        response.total = parseFloat(prices.reduce((acc, curr) => acc + curr, 0).toFixed(2));
        await createTransactionForUser(req.user, -(response.total), "BILLING", "PRODUCTS");
        const date = new Date();
        response.timestamp = `${date.getFullYear()}-${date.getMonth() > 9 ? date.getMonth() : "0" + date.getMonth()}-${date.getDate() > 9 ? date.getDate() : "0" + date.getDate()} ${date.getHours() > 9 ? date.getHours() : "0" + date.getHours()}:${date.getMinutes() > 9 ? date.getMinutes() : "0" + date.getMinutes()}:${date.getSeconds() > 9 ? date.getSeconds() : "0" + date.getSeconds()}`;
        //On crée la commande dans la BDD
        let order = await db.collection('orders').add({
            user_id: req.user.uid,
            items: req.body.items,
            total: response.total,
            status: "PENDING",
            timestamp: response.timestamp
        });
        //On retourne l'objet réponse
        return res.status(200).send({
            success: true, order: response
        });
    } catch (e) {
        //Si une erreur est survenue, on envoie une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route permettant de modifier le solde d'un utilisateur en ajoutant du crédit (/api/add-funds/)
router.patch('/add-funds', authMiddleware, async (req, res) => {
    try {
        //On récupère le montant passé dans la requête
        const amount = parseFloat(req.body.amount);
        //On récupère l'utilisateur depuis firestore
        let user = await (await db.collection('users').doc(`${req.user.uid}`).get()).data();
        //On effectue des verifications
        if (!amount || isNaN(amount) || amount < 5 || amount > 200 || user.balance + amount > 200)
            return res.status(400).send({
                success: false, error: "Bad request, change the amount"
            });
        await createTransactionForUser(req.user, amount, "TRANSFER", "ADD");
        //On ajoute le montant au solde de l'utilisateur
        user.balance = parseFloat((user.balance + amount).toFixed(2));
        //On met à jour l'utilisateur dans la BDD
        await db.collection('users').doc(`${req.user.uid}`).set(user);
        //On retourne la réponse avec le nouveau solde
        return res.status(200).send({
            success: true, balance: user.balance
        });
    } catch (e) {
        console.error(e)
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
})

//Route permettant de modifier le solde d'un utilisateur en retirant du crédit (/api/remove-funds/)
router.patch('/remove-funds', authMiddleware, async (req, res) => {
    try {
        //On récupère le montant passé dans la requête
        const amount = parseFloat(req.body.amount);
        //On récupère l'utilisateur depuis firestore
        let user = await (await db.collection('users').doc(`${req.user.uid}`).get()).data();
        //On effectue des verifications
        if (!amount || isNaN(amount) || amount <= 0)
            return res.status(400).send({
                success: false, error: "Bad request, change the amount"
            });
        if (user.balance - amount < 0)
            return res.status(400).send({
                success: false, error: "Bad request, you don't have enough funds"
            });
        await createTransactionForUser(req.user, -(amount), "TRANSFER", "REMOVE");
        //On ajoute le montant au solde de l'utilisateur
        user.balance = parseFloat((user.balance - amount).toFixed(2));
        //On met à jour l'utilisateur dans la BDD
        await db.collection('users').doc(`${req.user.uid}`).set(user);
        //On retourne la réponse avec le nouveau solde
        return res.status(200).send({
            success: true, balance: user.balance
        });
    } catch (e) {
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
})

//Route correspondant à la récupération du solde de l'utilisateur (/api/balance/)
router.get('/balance', authMiddleware, async (req, res) => {
    try {
        //On récupère l'utilisateur depuis firestore
        let user = await (await db.collection('users').doc(`${req.user.uid}`).get()).data();
        //On retourne la réponse avec le solde
        return res.status(200).send({
            success: true, balance: user.balance
        });
    } catch (e) {
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la récupération de l'historique des commandes d'un utilisateur (/api/order-history/)
router.get('/order-history', authMiddleware, async (req, res) => {
    try {
        //On récupère toutes les commandes ayant l'uid de l'utilisateur
        const data = [];
        const orderCollections = db.collection('orders')
        const snapshot = await orderCollections.where('user_id', '==', `${req.user.uid}`).get();
        //Si aucune commande n'a été trouvée, on retourne un message
        if (snapshot.empty) return res.status(200).send({
            success: true, history: "No recent orders"
        });
        for (let doc of snapshot.docs) {
            const order = doc.data();
            order.items = [];
            order.user_id = undefined;
            for (let item of (await orderCollections.doc(`${doc.id}`).collection('items').get()).docs) {
                order.items.push(item.data())
            }
            data.push(doc.id, order)
        }
        return res.status(200).send({
            success: true, history: data
        });
    } catch (e) {
        console.error(e)
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la récupération de l'historique des transactions d'un utilisateur (/api/transactions-history/)
router.get('/transactions-history', authMiddleware, async (req, res) => {
    try {
        const data = [];
        //On récupère toutes les transactions de l'utilisateur
        const snapshot = await db.collection('users').doc(`${req.user.uid}`).collection('transactions').limit(req.query.limit ? parseInt(req.query.limit) : 0).get();
        //Si aucune transaction n'a été trouvée, on retourne un message
        if (snapshot.empty) return res.status(200).send({
            success: true, history: "No recent transactions"
        });
        for (let doc of snapshot.docs) {
            data.push(doc.data())
        }
        return res.status(200).send({
            success: true, history: data
        });
    } catch (e) {
        console.error(e)
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la récupération de la liste des produits (/api/products-list/)
router.get('/products-list', async (req, res) => {
    try {
        const data = [];
        //On récupère toutes les transactions de l'utilisateur
        const snapshot = await db.collection('products').get();
        //Si aucune transaction n'a été trouvée, on retourne un message
        if (snapshot.empty) return res.status(200).send({
            success: true, list: "No products found"
        });
        for (let doc of snapshot.docs) {
            data.push(doc.data())
        }
        return res.status(200).send({
            success: true, list: data
        });
    } catch (e) {
        console.error(e)
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la vérification d'ouverture de la cafétaria (/api/is-open/)
router.get('/is-open', async (req, res) => {
    try {
        //On récupère une variable en BDD
        const snapshot = await db.collection('global_data').doc('charlemiam').get();
        if (snapshot.empty) return res.status(200).send({
            success: true, open: false
        });
        else return res.status(200).send({
            success: true, open: (snapshot.data()['is_open'] === true) ?? false
        });
    } catch (e) {
        console.error(e)
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la gestion d'ouverture de la cafétaria (/api/set-opening/)
router.patch('/set-opening', async (req, res) => {
    try {
        const open = req.body['opened'] === "true" ?? false;
        const document = await db.collection('global_data').doc('charlemiam');
        if (document.get().empty) return res.status(200).send({
            success: true, updated: false
        });
        else {
            await document.update({
                is_open: open
            });
            return res.status(200).send({
                success: true, updated: true
            });
        }
    } catch (e) {
        console.error(e)
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

module.exports = router;
