const InterestService = require('../service/interestService');


const interestService = new InterestService();


class InterestLinkerController {
    async firstTimeLinking(req, res) {
        try {
            console.log("first time links called");

            let { id } = req.decodedAccess;
            let { interestedIn } = req.body;
            // { name : value } pairs from frontend bc formdata will be sent


            let result = await interestService.linkingInterest({ id, interestedIn });

            //console.log("result" , result);

            return (result.success) ? res.status(200).json({
                success: true,
                message: "Interests linked successfully"
            }) : res.status(400).json({
                success: false,
                reason: result.reason
            });

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'InterestLinkerController.firstTimeLinking';
            }
            throw err;
        }
    }


    async updatingLinks(req, res) {
        try {
            console.log("Updating links called");


            let { id } = req.decodedAccess;
            let { interestedIn } = req.body;
            console.log(interestedIn);


            let result = await interestService.updatingLinksOfInterests({ id, interestedIn });

            return (result.success) ?
                res.status(200).json({
                    success: true,
                    message: "Interests updated successfully"
                }) : res.status(400).json({
                    success: false,
                    reason: result.reason
                });
        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'InterestLinkerController.updatingLinks';
            }
            throw err;
        }
    }


    async getUserInterests(req, res) {
        try {
            let { id } = req.decodedAccess;
            let result = await interestService.getUserInterest(id);

            if (result.success) {
                return res.status(200).json(result);
            }

            return res.status(400).json({ reason: result.reason })

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'InterestLinkerController.getUserInterests';
            }
            throw err;
        }
    }
}


module.exports = InterestLinkerController;
