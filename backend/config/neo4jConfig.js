const neo4j = require('neo4j-driver');

const dotenv = require('dotenv');

const path = require('path');


dotenv.config(
    {
        path: path.resolve(__dirname, '../.env')
    }
)

let { Neo4jPassword, Neo4jConnectionURI, Neo4jUser } = process.env;


// here we will create a driver and export it for others to use it
let driver = neo4j.driver(
    Neo4jConnectionURI,
    neo4j.auth.basic(
        Neo4jUser,
        Neo4jPassword
    )
);

async function isConnected() {
    try {
        return await driver.verifyConnectivity();
    } catch (err) {
        // if it is not throw an error
        console.log("Error while connecting with the graph ", err);
    }

}

isConnected();


module.exports = driver;