const mysql = require("mysql2");
require("dotenv").config();

const poolConfig = process.env.DATABASE_URL 
    ? process.env.DATABASE_URL 
    : {
        host: "localhost",
        user: "root",
        password: "",
        database: "gestion_fritos"
      };

const pool = mysql.createPool(poolConfig);

module.exports = pool.promise();