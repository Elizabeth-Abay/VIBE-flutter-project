const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');


dotenv.config(
    {
        path: path.resolve(__dirname, '../.env')
    }
);

const { MONGODB_URI } = process.env;


const connectMongoDB = async () => {
    try {
        // Connect to the local MongoDB server using the URI from your .env file
        const conn = await mongoose.connect(MONGODB_URI);

        //console.log(`MongoDB Connected Locally: ${conn.connection.host}`);
    } catch (error) {
        console.error(`Database Connection Error: ${error.message} `);
        // Exit the process immediately if the database fails to connect on startup
        process.exit(1);
    }
};

module.exports = connectMongoDB;