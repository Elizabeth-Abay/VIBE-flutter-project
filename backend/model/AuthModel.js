const pool = require('../config/pgConfig');

class AuthModelPg {
    async checkUserExist(email) {
        try {
            // table will be checked if email is there and has been verified before
            let query = `SELECT id FROM users WHERE email = $1 AND status = $2`
            // bc if result of this is null - new else reject
            let values = [email, 'verified'];

            let result = await pool.query(
                query, values
            );

            return {
                success: true,
                data: result.rows
            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelPg.checkUserExist';
            }
            throw err;
        }
    }



    // we use the otp + expiration when u resend code
    async createUser({ email, otpHashed }) {
        try {
            // if user exists and is not verified then update that
            let query = `
                INSERT INTO users(email , otp_hashed ,  otp_expires_at)  VALUES($1,$2 , CURRENT_TIMESTAMP + INTERVAL '5 minutes')
                ON CONFLICT(email)
                DO UPDATE SET otp_hashed = $2,
                updated_at = NOW()
                RETURNING id
                ;
            `

            let values = [email, otpHashed];

            let result = await pool.query(
                query, values
            )

            return {
                data: result.rows[0]
            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelPg.createUser';
            }
            throw err;
        }

    }


    async getOtp(id) {
        try {
            let query = 'SELECT otp_hashed FROM users WHERE id=$1 AND otp_expires_at > CURRENT_TIMESTAMP';

            let values = [id];

            let result = await pool.query(
                query, values
            )

            console.log(result.rows);


            if (result.rows.length === 1) {
                return {
                    success: true,
                    data: result.rows[0]
                }
            }

            return {
                success: false,
                reason: "Otp doesn't exist or is expired"
            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelPg.getOtp';
            }
            throw err;
        }
    }


    async setUserAsVerified(userId) {
        try {
            let query = `UPDATE users SET status = 'verified' WHERE id = $1 RETURNING id`;
            let values = [userId];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ?
                {
                    success: false
                } :
                {
                    success: true
                }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelPg.setUserAsVerified';
            }
            throw err;
        }
    }


    async getUserEmail(id) {
        try {
            let query = `
                    SELECT email 
                    FROM users
                    WHERE id = $1
                `;

            let values = [id];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ? { success: false, reason: "Couldn't find user" } : { success: true, data: result.rows[0] };



        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelPg.getUserEmail';
            }
            throw err;
        }
    }


    async resendOtp({ email, otpHashed }) {
        try {
            let query = `
                UPDATE users 
                SET otp_hashed = $1,
                otp_expires_at=CURRENT_TIMESTAMP + INTERVAL '5 minutes'
                WHERE email = $2
                RETURNING id
            `

            let values = [otpHashed, email];

            let result = await pool.query(
                query, values
            );

            return {
                success: true,
                data: result.rows
            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelPg.resendOtp';
            }
            throw err;
        }
    }


    async putInPassword({ id, passwordHashed }) {
        try {
            let query = `
                UPDATE users 
                SET password_hashed = $2
                WHERE id = $1
                RETURNING id
                `;

            let values = [id, passwordHashed];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ? { success: false, reason: "Couldn't put in password" } : { success: true };

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelPg.putInPassword';
            }
            throw err;
        }
    }


    async logIn(email) {
        try {
            let query = `
                SELECT id , password_hashed  
                FROM users 
                WHERE email = $1
                AND status = 'verified'
                `;

            let values = [email];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ?
                {
                    success: false,
                    reason: "Account dont exist"
                }
                :
                {
                    success: true,
                    data: result.rows[0]
                }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelPg.resendOtp';
            }
            throw err;
        }

    }

    async logOut(id) {
        try {
            let query = `
                UPDATE users
                SET status = 'logged-out'
                WHERE id = $1
                RETURNING id
            `;

            let values = [id];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ?
                {
                    success: false,
                    reason: "Account dont exist"
                }
                :
                {
                    success: true,
                    data: result.rows[0]
                }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelPg.logOut';
            }
            throw err;
        }
    }
}





module.exports = AuthModelPg