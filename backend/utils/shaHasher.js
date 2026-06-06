const crypto = require('crypto');

function shaHasher(valueToBeHashed) {
    try {
        return crypto.createHash('sha256').update(valueToBeHashed).digest('hex');
    } catch (err){
        err.from = "from utils sha1Hasher";

        throw err
    }
}


module.exports = shaHasher