const pool = require('../config/pgConfig');

class RefreshToken {
    async createRef({ userId, hashedRandomString }) {
        try {
            let query = 'INSERT INTO refresh_token(user_id , token_hash) VALUES ($1 , $2) RETURNING id'
            let values = [userId, hashedRandomString];

            let result = await pool.query(query, values);

            return (result.rows.length === 0) ?
                {
                    success: false,
                    reason: 'couldnt put in the ref token'
                }
                :

                {
                    success: true,
                    data: result.rows[0]
                }

        } catch (err) {
            err.from = 'RefreshToken.createRef'
            throw err
        }
    }

    async getRefTokenInfo(hashedTokenString) {
        try {
            let query = `
                SELECT user_id , id , is_revoked
                FROM refresh_token WHERE 
                is_revoked IS FALSE 
                AND token_hash = $1
                AND expires_at > NOW()
            `;

            let values = [hashedTokenString];

            let result = await pool.query(query, values);

            return result.rows.length === 0 ?
                {
                    success: false,
                    reason: 'couldnt find the ref token'
                }
                : {
                    success: true,
                    data: result.rows[0]
                }



        } catch (err) {
            err.from = 'RefreshToken.getRefTokenInfo'
            throw err
        }
    }

    async invalidateRefresh({ oldTokenId, newTokenId }) {
        try {
            // this will accept the new tokens id and put it into a chain in the refresh token  
            let query = `
                UPDATE refresh_token 
                SET replaced_by = $2,
                is_revoked = TRUE 
                WHERE id = $1 
                RETURNING id;
                `
            let values = [oldTokenId, newTokenId];

            let result = await pool.query(query, values);

            return (result.rows.length === 0) ?
                {
                    success: false,
                    reason: 'couldnt find the ref token'
                }
                :

                {
                    success: true,
                    data: result.rows[0]
                }
        } catch (err) {
            err.from = 'RefreshToken.invalidateRefresh'
            throw err
        }
    }

    async invalidateAll(userId) {
        try {
            let query = `
                UPDATE refresh_token 
                SET is_revoked = TRUE 
                where user_id = $1;
                `;
            let values = [userId];

            let result = await pool.query(query, values);


            return {
                success: true,
                count: result.rowCount
            }



        } catch (err) {
            err.from = 'RefreshToken.invalidateAll'
            throw err
        }
    }


    static async invalidateForLogOut(hashedRandom) {
        try {
            let query = `
                UPDATE refresh_token
                SET is_revoked = true
                WHERE token_hash = $1
                RETURNING id
            `;

            let values = [hashedRandom];

            let result = await pool.query(query, values);

            return (result.rowCount === 0)
                ?
                { success: false }
                :
                { success: true }


        } catch (err) {
            err.from = 'RefreshToken.invalidateForLogOut'
            throw err
        }
    }
}


module.exports = RefreshToken;