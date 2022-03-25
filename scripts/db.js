const {initializeApp, cert} = require('firebase-admin/app');
const {getFirestore} = require('firebase-admin/firestore');
const fs = require('fs');
const serviceAccount = require('./charlemi-app-b053ffa81bac.json');

const EMPTY_MODE = '';
const MIDDLE_DAY_MODE = '-m1';

initializeApp({
    credential: cert(serviceAccount)
});

let dbInit = async (rl) => {
    let mode;
    await new Promise(((resolve, reject) => {
        rl.question("Choose a mode to run : \n" + "\t1] Initial data\n" + "\t2] Midday data\n", async (answer) => {
            if (![1, 2].includes(parseInt(answer))) {
                reject('Invalid answer'.red);
            }
            mode = parseInt(answer) === 1 ? EMPTY_MODE : MIDDLE_DAY_MODE;
            resolve();
        });
    }));
    const db = getFirestore();
    console.log("Deleting [PRODUCTS] collection...".red);
    await db.collection('products').get().then(snapshot => {
        snapshot.forEach(async doc => {
            await db.collection('products').doc(doc.id).delete();
        });
    });
    console.log("Importing [PRODUCTS] collection...".green);
    let products = require(`./data/products${mode}.json`);
    for (let product of products) {
        await db.collection('products').doc(product.id).set(product)
        await new Promise(resolve => setTimeout(resolve, 500));
        console.log(`\t\tImporting product ${product.id}...`.yellow);
    }
    console.log("Deleting [GLOBAL_DATA] collection...".red);
    await db.collection('global_data').get().then(snapshot => {
        snapshot.forEach(async doc => {
            await db.collection('global_data').doc(doc.id).delete();
        });
    });
    console.log("Importing [GLOBAL_DATA] collection...".green);
    let global = require(`./data/global_data${mode}.json`);
    for (let document of global) await db.collection('global_data').doc(document.id).set(document.data);
    if (mode === MIDDLE_DAY_MODE) {
        console.log("Importing fake [ORDERS] collection...".green);
        let orders = require(`./data/generated_orders.json`);
        for (let document of orders) {
            document.timestamp = await generateTimestamp(false, true);
            document["instructions"].withdrawal = await generateTimestamp(true, true);
            await db.collection('orders').add(document);
        }
    }
}

let dbBackup = async () => {
    const db = getFirestore();
    const time = await generateTimestamp();
    if (!fs.existsSync('./backup')) fs.mkdirSync('./backup');
    if (!fs.existsSync('./backup/' + time)) fs.mkdirSync('./backup/' + time);
    console.log("Backup [PRODUCTS] collection...".magenta);
    let products = (await db.collection('products').get()).docs.map(doc => doc.data());
    fs.writeFileSync(`./backup/${time}/products.json`, JSON.stringify(products));
    console.log("Backup [ORDERS] collection...".magenta);
    let orders = (await db.collection('orders').get()).docs.map(doc => doc.data());
    fs.writeFileSync(`./backup/${time}/orders.json`, JSON.stringify(orders));
    console.log("Backup [USERS] collection...".magenta);
    let users = {};
    for (let user of (await db.collection('users').get()).docs) {
        const data = user.data();
        data['transactions'] = (await db.collection('users').doc(user.id).collection('transactions').get()).docs.map(doc => doc.data());
        users[user.id] = data;
    }
    fs.writeFileSync(`./backup/${time}/users.json`, JSON.stringify(users));
}

let generateTimestamp = async (after = false, withTime = false) => {
    const date = new Date(new Date().getTime() + (after ? 15 * 60 * 1000 : 0));
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    const hour = date.getHours();
    const minute = date.getMinutes();
    if (withTime)
        return `${year}-${month > 9 ? month : "0" + month}-${day > 9 ? day : "0" + day} ${hour > 9 ? hour : "0" + hour}:${minute > 9 ? minute : "0" + minute}`;
    else
        return `${year}-${month > 9 ? month : "0" + month}-${day > 9 ? day : "0" + day}`;
}

module.exports = {
    dbInit, dbBackup
};
