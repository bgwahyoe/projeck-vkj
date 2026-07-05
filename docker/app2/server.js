const express = require("express");
const mysql = require("mysql2");

const app = express();

const db = mysql.createConnection({
    host: "192.168.56.10",
    user: "dmzuser",
    password: "password123",
    database: "project_vkj"
});

db.connect((err) => {

    if (err) {

        console.log(err);

    } else {

        console.log("Database Connected!");

    }

});

app.get("/", (req, res) => {

    res.send(`
        <h1>APP2 - NodeJS</h1>
        <h2>Database Connected ✅</h2>
        <p>Server Time: ${new Date()}</p>
    `);

});

app.listen(3000, () => {

    console.log("Running on 3000");

});