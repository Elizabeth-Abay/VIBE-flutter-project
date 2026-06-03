const RequestService = require('../service/requestService');


const requestService = new RequestService();


class RequestController {
    async cancelRequest(req, res, next) {
        try {
            // { id , canceled }
            let { id } = req.decodedAccess;
            let { canceled } = req.body;

            console.log(`cancelRequest ${canceled}`);

            let result = await requestService.cancelConnectionRequest({ id, canceled });

            console.log(` cancelRequest ${result}`);


            return (result.success) ? res.status(200).json({ success: true }) : res.status(400).json(result);

        } catch (err) {
            // the lower layers will throw and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'RequestController.cancelRequest';
            }
            next(err);
        }

    }


    async getSentRequests(req, res, next) {
        try {
            let { id } = req.decodedAccess;
            let result = await requestService.getSentRequests(id);

            console.log(`getSentRequests ${result}`);

            return (result.success) ? res.status(200).json(result) : res.status(400).json(result);

        } catch (err) {
            // the lower layers will throw and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'RequestController.getSentRequests';
            }
            next(err);
        }
    }



    async getPendingRequests(req, res, next) {
        try {
            let { id } = req.decodedAccess;
            let result = await requestService.getPendingRequests(id);

            console.log(`getPendingRequests ${result}`);


            return (result.success) ? res.status(200).json(result) : res.status(400).json(result);


        } catch (err) {
            // the lower layers will throw and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'RequestController.getPendingRequests';
            }
            next(err);
        }
    }
}



module.exports = RequestController;