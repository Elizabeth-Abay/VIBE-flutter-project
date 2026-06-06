const DeleteAccService = require('../service/deleteAccService');

class DeleteAccController {
    static async deleteAcc(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let { randomString } = req.decodedRefresh;

            let result = await DeleteAccService.deleteAcc({ id, randomString });

            return (result.success) ?
                res.status(200).json(result)
                :
                res.status(400).json(result)

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'DeleteAccController.deleteAcc';
            }
            next(err);
        }
    }
}

module.exports = DeleteAccController;