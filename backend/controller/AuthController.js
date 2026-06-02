const AuthService = require('../service/authService');

const authService = new AuthService();

class AuthController {
    constructor() { }

    async createUser(req, res, next) {
        // to be able to call the global error handler in case of error
        try {
            console.log("Request received");
            // validator already called in the routes
            let { email } = req.body;

            let result = await authService.createUser(email);

            return result.success ?
                res.status(201).json({ id: result.data })
                :
                res.status(400).json(result)


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = "AuthControllers.createUser";
            }

            next(err); // this will call the error handler
        }
    }


    async verifyUserOtp(req, res, next) {
        try {
            
            let { id, OTP } = req.body;

            console.log("Verifying otp" , { id, OTP })

            

            let result = await authService.verifyUser({ id, OTP })

            return result.success ?
                res.status(200).json(result.data)
                :
                res.status(400).json(result);

            // result.data - contain { accessToken,refreshToken }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthControllers.verifyUser';
            }
            next(err);
        }
    }


    async resendOtp(req, res, next) {
        try {
            let { id } = req.body;
            let result = await authService.resendOtp(id);

            return (result.success) ?
                res.status(200).json(result)
                :
                res.status(400).json(result)

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthControllers.resendOtp';
            }
            next(err);
        }

    }




    async logIn(req, res, next) {
        try {
            // email and password
            let { email, password } = req.body;

            let result = await authService.logIn({ email, password });

            return result.success ?
                res.status(200).json(result.data) :
                res.status(400).json(result);


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthControllers.logIn';
            }
            next(err);
        }
    }


    async logOut(req, res, next) {
        try {
            let { randomString } = req.decodedRefresh;

            let result = await authService.logOut(randomString);

            return result.success
                ?
                res.status(200).json(result)
                :
                res.status(400).json(result);



        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthControllers.logOut';
            }
            next(err);
        }
    }

}


module.exports = AuthController;