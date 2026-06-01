const BlockService = require('../service/blockService');

const blockService = new BlockService();

class BlockController {
    async getAllBlocked(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let result = await blockService.getAllBlocked(id);

            return (result.success)
                ?
                res.status(200).json(result)
                :
                res.status(400).json(result)

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockController.getAllBlocked'
            }
            next(err);

        }

    }

    async blockUser(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let { blockedUser } = req.body;

            let result = await blockService.blockUser({ id, blockedUser });

            return (result.success)
                ?
                res.status(200).json(result)
                :
                res.status(400).json(result);



        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockController.blockUser'
            }
            next(err);
        }
    }

    async unblockUser(req, res, next) {
        try {
            let { id } = req.decodedAccess;

            let { unblockedUser } = req.body;

            let result = await blockService.unblockUser({ id, unblockedUser });

            return (result.success)
                ?
                res.status(200).json(result)
                :
                res.status(400).json(result);


        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = 'BlockController.unblockUser'
            }
            next(err);

        }
    }


}


module.exports = BlockController;