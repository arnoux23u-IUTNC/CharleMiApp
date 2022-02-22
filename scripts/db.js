const {initializeApp, applicationDefault, cert} = require('firebase-admin/app');
const {getFirestore, Timestamp, FieldValue} = require('firebase-admin/firestore');
const serviceAccount = require('./charlemi-app-b053ffa81bac.json');
const products = require("./data/products.json");

initializeApp({
    credential: cert(serviceAccount)
});

let dbInit = async () => {
    const db = getFirestore();
    console.log("Deleting [PRODUCTS] collection...".red);
    await db.collection('products').get().then(snapshot => {
        snapshot.forEach(async doc => {
            await db.collection('products').doc(doc.id).delete();
        });
    });
    console.log("Importing [PRODUCTS] collection...".green);
    let products = require('./data/products.json');
    products.forEach(async product => {
        await db.collection('products').doc(product.id).set(product);
    }, err => {
        console.log(err);
    });
    console.log("Deleting [GLOBAL_DATA] collection...".red);
    await db.collection('global_data').get().then(snapshot => {
        snapshot.forEach(async doc => {
            await db.collection('global_data').doc(doc.id).delete();
        });
    });
    console.log("Importing [GLOBAL_DATA] collection...".green);
    let global = require('./data/global_data.json');
    global.forEach(async document => {
        await db.collection('global_data').doc(document.id).set(document.data);
    }, err => {
        console.log(err);
    });
}

module.exports = {
    dbInit
};