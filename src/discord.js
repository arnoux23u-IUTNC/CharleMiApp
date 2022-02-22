const discord = require('discord.js');
const {MessageEmbed} = require("discord.js");
const client = new discord.Client({intents: 32767});

let startBot = async () => {
    try {
        await client.login(process.env.DISCORD_TOKEN);
        console.log("Discord connected as " + client.user.tag);
    } catch (err) {
        console.log("Discord connection failed");
    }
}

let sendWarn = async (title, err, uid, error = false) => {
    const embed = new MessageEmbed()
        .setTitle(`Error while trying to **${title}**`)
        .setDescription(`${err}`)
        .addField("USER UID", `${uid.substr(0, 10) + "..." ?? "N/A"}`)
        .setColor(error ? "RED" : "ORANGE")
        .setTimestamp();
    const channel = await (await client.guilds.cache.get("896023729065328701")).channels.cache.get("945808091134443570");
    await channel.send({embeds: [embed]});
}

module.exports = {
    startBot,
    client,
    sendWarn
}