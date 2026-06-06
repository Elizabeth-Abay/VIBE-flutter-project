const crypto = require('crypto');

function generateString() {
    return crypto.randomBytes(64).toString("hex");
}

module.exports = generateString