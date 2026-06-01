const RefreshTokenService = require('../service/refreshingTokensService');

class TokenController {
    static async tokenGeneration(req, res, next) {
        try {
            // call the token generation logic
            let { randomString } = req.decodedRefresh;

            console.log("Random string successfully found", randomString);


            let result = await RefreshTokenService.generateNewTokens(randomString);

            return (result.success)
                ?
                res.status(200).json(result)
                :
                res.status(400).json(result)

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                err.from = "TokenController.tokenGeneration";
            }
            next(err)
        }
    }
}

module.exports = TokenController;