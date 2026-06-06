const pool = require('../config/pgConfig');


class UserProfileGetter {
    // given array of ids get their picture , username and name
    static async getProfileInfo(userIdArr) {
        try {

            let query = `
                    SELECT 
                        name , 
                        user_name , 
                        user_id , 
                        bio
                        profile_url
                    FROM profile_info
                    WHERE user_id = ANY($1)
                `

            let values = [userIdArr];


            let result = await pool.query(query, values);

            // //console.log("result  from gettingProfile" , result);

            return (result.rowCount === 0) ?
                {
                    success : false,
                    reason : "Problem getting user profile from UserProfileGetter.getProfileInfo"
                }
                :
                {
                    success : true,
                    data : result.rows
                    // the expected array of users
                }
        } catch (err) {
            err.from = 'UserProfileGetter.getProfileInfo';
            throw (err);
        }
    }
}

module.exports = UserProfileGetter;