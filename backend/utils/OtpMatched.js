function doesOtpMatch(otpFromDb, otpFromUserHashed) {
    if (otpFromDb.trim() === otpFromUserHashed.trim()) {
        return true
    }

    return false;
}


module.exports = doesOtpMatch;