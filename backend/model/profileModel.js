const pool = require('../config/pgConfig');

class ProfileFristTimeModel {

    async checkUniqueUserName(userName) {
        try {
            // first check if username is unique
            let query = 'SELECT id FROM profile_info WHERE user_name = $1';
            let values = [userName];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ? { success: true } : { success: false }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ProfileModel.checkUniqueUserName';
            }
            throw err;
        }
    }

    async settingProfileFirstTime({ id, name, userName }) {
        try {
            // inserting for the first time
            console.log("{ id, name, userName } when setting profiles " , { id, name, userName });
            let query = `
                INSERT INTO profile_info(name , user_name , user_id )
                VALUES($1,$2 , $3)
                RETURNING id
            `

            let values = [name, userName, id];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ? { success: false } : { success: true }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ProfileModel.settingProfileFirstTime';
            }
            throw err;
        }
    }




    async settingProfilePic({ id, profilePicUrl }) {
        try {
            // wld do an update request to your bio
            // using the desktop as storage currently so better use update command
            let query = `
                UPDATE profile_info 
                SET profile_url = $2
                WHERE user_id = $1
                RETURNING *
            `;

            let values = [id, profilePicUrl];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ? { success: false } : { success: true }


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ProfileModel.settingBioAndPP';
            }
            throw err;
        }

    }


    async settingNameAndBio({ id, name, bio, whichUpdated }) {
        try {
            // wld do an update request to your bio
            // using the desktop as storage currently so better use update command
            let query;
            let values;

            if (whichUpdated === 'name') {
                query = `
                    UPDATE profile_info 
                    SET name = $2
                    WHERE user_id = $1
                    RETURNING *
                `;

                values = [id, name];

            }

            else if (whichUpdated === 'bio') {
                query = `
                    UPDATE profile_info 
                    SET bio = $2
                    WHERE user_id = $1
                    RETURNING *
                    `;

                values = [id,  bio];
            }

            else {
                query = `
                    UPDATE profile_info 
                    SET name = $2 , bio = $3
                    WHERE user_id = $1
                    RETURNING *
                `;

                values = [id, name, bio];


            }



            let result = await pool.query(query, values);


            return (result.rowCount === 0) ? { success: false } : { success: true }


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ProfileModel.settingNameAndBio';
            }
            throw err;
        }

    }


    async settingUserName({ id, userName }) {
        try {
            // wld do an update request to your bio
            // using the desktop as storage currently so better use update command
            let query = `
                UPDATE profile_info 
                SET user_name = $2
                WHERE user_id = $1
                RETURNING *
            `;

            let values = [id, userName];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ? { success: false } : { success: true }


        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'ProfileModel.settingUserName';
            }
            throw err;
        }

    }
}

module.exports = ProfileFristTimeModel;