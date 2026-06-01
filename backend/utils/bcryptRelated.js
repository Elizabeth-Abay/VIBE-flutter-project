const bcrypt = require('bcrypt');


class BcryptRelated {
    static async bcryptHasher(valueToBeHashed) {
        try {
            let saltgen = await bcrypt.genSalt();
            let hashedVal = await bcrypt.hash(valueToBeHashed, saltgen);

            return hashedVal;

        } catch (err) {
            err.from = 'BcryptRelated.bcrypt Hasher';

            throw err;
        }
    }

    static async bcryptCompare(unHashedValue, hashedValue) {
        try {
            // returns a boolean val
           return await bcrypt.compare(unHashedValue, hashedValue);

        } catch (err) {
            err.from = 'BcryptRelated.bcrypt Hasher';

            throw err;
        }
    }

}



module.exports = BcryptRelated;