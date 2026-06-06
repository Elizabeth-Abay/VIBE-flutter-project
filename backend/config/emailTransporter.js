const dotenv = require('dotenv');
const nodeMailer = require('nodemailer')

const emailTransporter = nodeMailer.createTransport({
    host: 'smtp.gmail.com', // means the emails i send live here 
    port: 587, // use this port to send out the emails
    secure: false,
    auth: {
        user: process.env.EMAIL,
        pass: process.env.EMAIL_PASSWORD 
        // is the password for the app to be able to send 
        // emails through the provided email not ur actual email password
    },
    tls: { rejectUnauthorized: false } // bypass certificate validation  for development only reverse this once through dev't
})

module.exports = emailTransporter