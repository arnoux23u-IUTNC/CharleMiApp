//Middleware d'authentification

const {RUNNING_PROD} = require('../app.js');
const {getAuth} = require('firebase-admin/auth')

module.exports = async (req, res, next) => {
    //Récupération du token dans la requête
    const token = req.body.token || req.query.token || req.header('x-auth-token');
    //Si le token n'est pas présent, on renvoie une erreur
    if (!token)
        return res.status(403).send({success: false, msg: 'No token, authorization denied'});
    try {
        //On récupère l'utilisateur correspondant au token dans firebase
        req.user = await getAuth().getUser(token);
        //Si l'utilisateur est invalide, on renvoie une erreur
        if (req.user.disabled || (!req.user.emailVerified && RUNNING_PROD)) {
            return res.status(401).send({success: false, msg: 'No user, authorization denied. Contact admin'});
        }
        next();
    } catch (e) {
        //Exception générée si l'utilisateur n'existe pas
        return res.status(401).send({success: false, msg: 'Invalid token'});
    }
}
