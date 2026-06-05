const path = require('path');
const emailTransporter = require('../config/emailTransporter');
const renderEjs = require('../utils/renderingEjs');


class EmailSendingFunctions {

    static async sendingOTPEmail({ email, OTP }) {
        try {
            let templatePath = path.join(__dirname, '../views/otpTemplate.ejs');
            // //console.log("tempalatePath" , tempalatePath);

            const html = await renderEjs({ templatePath, placeHolders: { otp: OTP } });

            let result = await emailTransporter.sendMail({
                from: `VIBE NOTIFICATIONS`,
                to: email,
                subject: 'OTP verification',
                html
            });

        } catch (err) {
            err.from = 'sendingOTPEmail';

            throw err

        }
    }

}




module.exports = EmailSendingFunctions