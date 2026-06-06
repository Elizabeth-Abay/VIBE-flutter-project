// token middlewares 
// for access and refresh token they will verify -> decode

const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const path = require('path');


dotenv.config({
    path: path.resolve(__dirname, '../.env')
})

let { ACCESS_TOKEN_SECRET, REFRESH_TOKEN_SECRET } = process.env;
// //console.log("ACCESS_TOKEN_SECRET" , ACCESS_TOKEN_SECRET );


class TokenDecoder {
    // this class checks the signature and expiration
    static accessDecode(req, res, next) {
        try {
            // access token - header
            // signedInfo = { id , exp} 
            let token = req.headers['authorization'];
            // //console.log("token " , token);


            let access = token?.split(' ')[1];
            // //console.log("access " , access);

            const jwtPattern = /^[a-zA-Z0-9-_]+\.[a-zA-Z0-9-_]+\.[a-zA-Z0-9-_]+$/;

            if (!access || !jwtPattern.test(access)) throw Error('the access token not there or not have proper structure');

            
            req.decodedAccess = jwt.verify(access, ACCESS_TOKEN_SECRET);

            // //console.log("decoded access" ,req.decodedAccess)

            return next();

        } catch (err) {
            err.from = 'TokenDecoder.accessDecode '
            err.status = 401;

            next(err)
        }
    }



    static refreshDecoder(req, res, next) {

        let { refreshToken } = req?.body;

        try {

            if (!refreshToken) throw Error('the refresh token not there')
            req.decodedRefresh = jwt.verify(refreshToken, REFRESH_TOKEN_SECRET);

            return next();
        } catch (err) {
            err.from = 'TokenDecoder.refreshDecoder '
            err.status = 401;
            if (err.name === 'TokenExpiredError') err.message = "Session expired. Please login again.";
            if (err.name === 'JsonWebTokenError') err.message = "Invalid security token.";

            next(err);
        }

    }

}





module.exports = TokenDecoder;