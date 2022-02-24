const {Client, MessageEmbed} = require("discord.js");
const client = new Client({intents: 32767});

let sendWarn = async (title, err, uid, error = false) => {
    try {
        await client.login(process.env.DISCORD_TOKEN);
        const embed = new MessageEmbed()
            .setTitle(`Error while trying to **${title}**`)
            .setDescription(`${err}`)
            .addField("USER UID", `${uid.substring(0, 10) + "..." ?? "N/A"}`)
            .setColor(error ? "RED" : "ORANGE")
            .setTimestamp();
        const channel = await client.channels.fetch("945808091134443570");
        await channel.send({embeds: [embed]});
    } catch (err) {
        console.log("Discord connection failed");
    }
}

module.exports = {
    sendWarn
}
