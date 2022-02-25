const router = require('express').Router();
const authMiddleware = require('./middleware/auth');
const {
    placeOrder,
    addFunds,
    removeFunds,
    getBalance,
    getOrders,
    getProducts,
    getTransactions,
    getCategories,
    isOpen,
    setOpening
} = require("./workers/functions");
const {sendWarn} = require("./workers/discord");

//Route correspondant à la création d'une commande (/api/place-order/)
router.post('/place-order', authMiddleware, async (req, res) => {
    try {
        const response = await placeOrder(req, res)
        //On retourne l'objet réponse
        switch (response) {
            case "CLOSED":
                return res.status(401).send({
                    success: false, message: "Charlemiam is closed"
                });
            case "NOT_ENOUGH_FUNDS":
                return res.status(401).send({
                    success: false, message: "Not enough funds"
                });
            case "MONEY_LESS_THAN_ZERO":
                return res.status(401).send({
                    success: false, message: "Invalid order"
                });
            default:
                return res.status(200).send({
                    success: true, order: response
                });
        }
    } catch (e) {
        console.error(e)
        //await sendWarn('Create order', e, req.user.uid);
        //Si une erreur est survenue, on envoie une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route permettant de modifier le solde d'un utilisateur en ajoutant du crédit (/api/add-funds/)
router.patch('/add-funds', authMiddleware, async (req, res) => {
    try {
        const response = await addFunds(req);
        if (response === false) return res.status(400).send({
            success: false, error: "Bad request, change the amount"
        });
        return res.status(200).send({
            success: true, balance: response
        });
    } catch (e) {
        await sendWarn('Add funds', e, req.user.uid);
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
})

//Route permettant de modifier le solde d'un utilisateur en retirant du crédit (/api/remove-funds/)
router.patch('/remove-funds', authMiddleware, async (req, res) => {
    try {
        const response = await removeFunds(req);
        if (response === false)
            return res.status(400).send({
                success: false, error: "Bad request, change the amount"
            });
        else if (response === "NEF") {
            return res.status(400).send({
                success: false, error: "Bad request, you don't have enough funds"
            });
        }
        //On retourne la réponse avec le nouveau solde
        return res.status(200).send({
            success: true, balance: response
        });
    } catch (e) {
        await sendWarn('Remove funds', e, req.user.uid);
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
})

//Route correspondant à la récupération du solde de l'utilisateur (/api/balance/)
router.get('/balance', authMiddleware, async (req, res) => {
    try {
        const balance = await getBalance(req);
        return res.status(200).send({
            success: true, balance: balance
        });
    } catch (e) {
        await sendWarn('Get balance', e, req.user.uid);
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la récupération de l'historique des commandes d'un utilisateur (/api/order-history/)
router.get('/order-history', authMiddleware, async (req, res) => {
    try {
        const data = await getOrders(req);
        //Si aucune commande n'a été trouvée, on retourne un message
        if (data === false) return res.status(200).send({
            success: true, history: "No recent orders"
        });
        else return res.status(200).send({
            success: true, history: data
        });
    } catch (e) {
        await sendWarn('Get orders history', e, req.user.uid);
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la récupération de l'historique des transactions d'un utilisateur (/api/transactions-history/)
router.get('/transactions-history', authMiddleware, async (req, res) => {
    try {
        const data = await getTransactions(req);
        if (data === false) return res.status(200).send({
            success: true, history: "No recent transactions"
        });
        else return res.status(200).send({
            success: true, history: data
        });
    } catch (e) {
        await sendWarn('Get transaction history', e, req.user.uid);
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la récupération des categories (/api/product-categories/)
router.get('/product-categories', async (req, res) => {
    try {
        const data = await getCategories();
        if (data === false) return res.status(200).send({
            success: true, categories: "No categories found"
        });
        else return res.status(200).send({
            success: true, categories: data
        });
    } catch (e) {
        await sendWarn('Get categories', e, req.user.uid);
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la récupération de la liste des produits (/api/products-list/)
router.get('/products-list', async (req, res) => {
    try {
        const data = await getProducts();
        if (data === false)
            return res.status(200).send({
                success: true, list: "No products found"
            });
        else
            return res.status(200).send({
                success: true, list: data
            });
    } catch (e) {
        await sendWarn('Get products list', e);
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }


});

//Route correspondant à la vérification d'ouverture de la cafétaria (/api/is-open/)
router.get('/is-open', authMiddleware, async (req, res) => {
    try {
        const open = await isOpen();
        return res.status(200).send({
            success: true, open: open
        });
    } catch (e) {
        await sendWarn('Get opening status', e);
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

//Route correspondant à la gestion d'ouverture de la cafétaria (/api/set-opening/)
router.patch('/set-opening', authMiddleware, async (req, res) => {
    try {
        const updated = await setOpening(req);
        return res.status(200).send({
            success: true, updated: updated
        });
    } catch (e) {
        await sendWarn('Change opening status', e, req.user.uid);
        //En cas d'erreur, on retourne une autre réponse
        return res.status(500).send({
            success: false, error: "Internal server error"
        });
    }
});

module.exports = router;
