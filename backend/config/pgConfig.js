const pg = require('pg');

const dotenv = require('dotenv');

// const crypto = require('crypto'); something learnt in the model layer u dont need hashing..

const path = require('path');



dotenv.config({ path: path.resolve(__dirname, '../.env') });
// we need to store our password and this things in a secret place


const { data_base_host, data_base_user, data_base_password, data_base_used } = process.env;

let pool = new pg.Pool({
    host: data_base_host,
    user: data_base_user,
    password: data_base_password,
    database: data_base_used,
    connectionLimit: 20
})



module.exports = pool 