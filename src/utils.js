const {getFirestore} = require("firebase-admin/firestore");
const db = getFirestore();

let createTransactionForUser = async (user, amount, type, category, desc = "", tags = [], notes = "") => {
    const dateObject = new Date();
    await db.collection("users").doc(user.uid).collection("transactions").add({
        date: `${dateObject.getFullYear()}-${(dateObject.getMonth() +1) > 9 ? (dateObject.getMonth() +1) : "0" + (dateObject.getMonth() +1)}-${dateObject.getDate() > 9 ? dateObject.getDate() : "0" + dateObject.getDate()} ${dateObject.getHours() > 9 ? dateObject.getHours() : "0" + dateObject.getHours()}:${dateObject.getMinutes() > 9 ? dateObject.getMinutes() : "0" + dateObject.getMinutes()}:${dateObject.getSeconds() > 9 ? dateObject.getSeconds() : "0" + dateObject.getSeconds()}`,
        amount: amount,
        type: type,
        description: desc,
        category: category,
        tags: tags,
        notes: notes,
    });
}

module.exports = {
    createTransactionForUser
}
