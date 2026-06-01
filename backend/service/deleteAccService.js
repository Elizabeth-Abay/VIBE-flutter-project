const shaHasher = require('../utils/shaHasher');
const { RefreshToken } = require('./tokenGeneration');
const DeleteAcc = require('../model/DeleteAccModel');

const refToken = new RefreshToken();


class DeleteAccService {
    static async deleteAcc({ id, randomString }) {
        try {
            // get the info from randomString
            let hashedRandom = shaHasher(randomString);


            // invalidate all refresh tokend
            let invalidateAllRef = await refToken.invalidateAllRefresh(id);

            if (!invalidateAllRef) return invalidateAllRef;

            // delete the user
            let deleteUserResult = await DeleteAcc.deleteUser(id);

            return deleteUserResult;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'DeleteAccController.deleteAcc';
            }
            next(err);
        }
    }
}

module.exports = DeleteAccService;