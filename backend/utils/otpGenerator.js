const OtpGenerator = require('otp-generator');

function generateOTP() {
    try {
        return OtpGenerator.generate(
            6, {
            digits: true,
            upperCaseAlphabets: true,
            lowerCaseAlphabets: true
        }
        );

    } catch (err) {
        err.from = 'from utils generateOTP'

        throw err
    }

}


module.exports = generateOTP