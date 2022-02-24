const {getFirestore} = require("firebase-admin/firestore");
const db = getFirestore();

let createTransactionForUser = async (user, amount, type, category, desc = "", tags = [], notes = "") => {
    //TODO PEUT ETRE CENTRALISER LA MODIFICATION DE LA BALANCE
    await db.collection("users").doc(user.uid).collection("transactions").add({
        date: generateTimestamp(),
        amount: amount,
        type: type,
        description: desc,
        category: category,
        tags: tags,
        notes: notes,
    });
}

let generateTimestamp = () => {
    const date = new Date();
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    const hour = date.getHours();
    const minute = date.getMinutes();
    const second = date.getSeconds();
    return `${year}-${month > 9 ? month : "0" + month}-${day > 9 ? day : "0" + day} ${hour > 9 ? hour : "0" + hour}:${minute > 9 ? minute : "0" + minute}:${second > 9 ? second : "0" + second}`;
}

module.exports = {
    createTransactionForUser,
    generateTimestamp
}
