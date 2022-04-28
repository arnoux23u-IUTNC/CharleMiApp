const readline = require("readline");
const {dbInit, dbBackup, removeFake} = require("./db.js");
require("colors");

const questions = "\t1] Init database\n" +
    "\t2] Backup database\n" +
    "\t3] Remove fake data\n";

let startapp = async () => {
    console.log("Starting app...");
    let rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });
    await rl.question("Choose an action to run : \n" + questions, async (answer) => {
        switch (answer) {
            case "1":
                console.log("[INIT DATABASE]".blue);
                await dbInit(rl).catch(err => console.log(err));
                break;
            case "2":
                console.log("[BACKUP DATABASE]".blue);
                await dbBackup();
                break;
            case "3":
                console.log("[REMOVE FAKE DATA]".blue);
                await removeFake();
                break;
            default:
                console.log("Goodbye!".red);
                break;
        }
        rl.close();
        console.log("[FINISHED]".blue)
    });
};

startapp().catch(e => console.error(e));
