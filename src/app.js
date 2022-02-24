//Import des modules et des fichiers d'envirronement
const express = require('express');
const {initializeApp, cert} = require('firebase-admin/app');
const credentials = require("../charlemi-app-b053ffa81bac.json");
require('dotenv').config();
//On definit un booleen, a vrai si nous sommes en production
const RUNNING_PROD = process.env.RUNNING_SYSTEM === "PROD";

//Initialisation de l'app
initializeApp({credential: cert(credentials)});
const app = express();

//Utilisation de modules au sein de l'application
app.use(express.json({limit: '10mb'}));
app.use(express.urlencoded({limit: '10mb', extended: true}));

//On stipule ici que tout le traffic arrivant sur l'url /api sera redirigé vers le fichier router.js
app.use('/api', require('./router.js'));

//Démmarage de l'application sur le port désiré
app.listen(RUNNING_PROD ? process.env.SERVED_PORT_PROD : process.env.SERVED_PORT_DEV, async function () {
    console.log(`Server is listening on port ${this.address().port}`);
});

module.exports = {
    RUNNING_PROD
}
