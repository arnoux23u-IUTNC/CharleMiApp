const router = require('express').Router();
const authMiddleware = require('./middleware/auth');
const {getFirestore} = require("firebase-admin/firestore");

const db = getFirestore();

//Route correspondant à la création d'une commande (/api/place-order/)
router.post('/place-order', authMiddleware, async (req, res) => {
    try {
        //let user = await (await db.collection('users').doc(`${req.user.uid}`).get()).data();
        //On crée un objet vide qui sera la réponse retournée
        const response = [];
        response.user_uid = req.user.uid;
        //Calcul du total de la commande depuis la BDD
        let total = 0;
        let prices = await Promise.all(req.body.items.map(async (product) => total += Math.max(product['qte'], 0) * (await (await db.collection('products').doc(`${product['product_id']}`).get()).data()).price));
        response.total = prices.reduce((acc, curr) => acc + curr, 0);
        const date = new Date();
        response.timestamp = `${date.getFullYear()}-${date.getMonth() > 9 ? date.getMonth() : "0" + date.getMonth()}-${date.getDate() > 9 ? date.getDate() : "0" + date.getDate()} ${date.getHours() > 9 ? date.getHours() : "0" + date.getHours()}:${date.getMinutes() > 9 ? date.getMinutes() : "0" + date.getMinutes()}:${date.getSeconds() > 9 ? date.getSeconds() : "0" + date.getSeconds()}`;
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

//Route correspondant à la récupération du solde de l'utilisateue (/api/balance/)
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

module.exports = router;
