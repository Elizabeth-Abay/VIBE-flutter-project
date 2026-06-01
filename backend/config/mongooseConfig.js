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

        console.log(`MongoDB Connected Locally: ${conn.connection.host}`);
    } catch (error) {
        console.error(`Database Connection Error: ${error.message} `);
        // Exit the process immediately if the database fails to connect on startup
        process.exit(1);
    }
};
// mongooseConfig.js

const mongoose = require("mongoose");

const DEFAULT_OPTIONS = {
  autoIndex: true,
  maxPoolSize: 10,
  minPoolSize: 2,
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,
};

mongoose.set("strictQuery", true);

const connectionEvents = () => {
  mongoose.connection.on("connected", () => {
    console.log("MongoDB connected successfully");
  });

  mongoose.connection.on("error", (err) => {
    console.error("MongoDB connection error:", err.message);
  });

  mongoose.connection.on("disconnected", () => {
    console.warn("MongoDB disconnected");
  });

  process.on("SIGINT", async () => {
    try {
      await mongoose.connection.close();
      console.log("MongoDB connection closed");
      process.exit(0);
    } catch (error) {
      console.error("Error closing MongoDB:", error);
      process.exit(1);
    }
  });
};

const connectDB = async () => {
  try {
    const mongoUri = process.env.MONGO_URI;

    if (!mongoUri) {
      throw new Error("MONGO_URI environment variable is missing");
    }

    const connection = await mongoose.connect(
      mongoUri,
      DEFAULT_OPTIONS
    );

    console.log(
      `Database connected: ${connection.connection.host}`
    );

    return connection;
  } catch (error) {
    console.error("Database connection failed:");
    console.error(error.message);
    process.exit(1);
  }
};

const disconnectDB = async () => {
  try {
    await mongoose.disconnect();
    console.log("Database disconnected successfully");
  } catch (error) {
    console.error("Failed to disconnect database:", error.message);
  }
};

const getConnectionState = () => {
  const states = {
    0: "Disconnected",
    1: "Connected",
    2: "Connecting",
    3: "Disconnecting",
  };

  return states[mongoose.connection.readyState];
};

const healthCheck = async () => {
  try {
    await mongoose.connection.db.admin().ping();

    return {
      status: "healthy",
      state: getConnectionState(),
      database: mongoose.connection.name,
      host: mongoose.connection.host,
    };
  } catch (error) {
    return {
      status: "unhealthy",
      error: error.message,
    };
  }
};

const reconnectDatabase = async () => {
  try {
    await disconnectDB();
    await connectDB();

    console.log("Database reconnected successfully");
  } catch (error) {
    console.error("Reconnection failed:", error.message);
  }
};

const databaseInfo = () => {
  return {
    host: mongoose.connection.host,
    name: mongoose.connection.name,
    port: mongoose.connection.port,
    state: getConnectionState(),
  };
};

connectionEvents();

module.exports = {
  connectDB,
  disconnectDB,
  reconnectDatabase,
  getConnectionState,
  healthCheck,
  databaseInfo,
  mongoose,
};
module.exports = connectMongoDB;