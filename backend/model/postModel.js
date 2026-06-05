const pool = require('../config/pgConfig');


class PostModel {
    async extractPostInformation(postIdArray) {
        try {

            //console.log(postIdArray)
            let query = `
                SELECT 
                    p.id AS post_id,
                    p.title,
                    p.content,
                    p.image_url AS post_image,
                    p.category,
                    u.user_id AS author_id,
                    u.user_name,
                    u.name,
                    u.profile_url AS author_profile_picture
                FROM posts p
                INNER JOIN profile_info u ON p.user_id = u.user_id
                WHERE p.id = ANY($1);
            `

            let values = [postIdArray];

            let result = await pool.query(query, values);

            //console.log(result.rows)

            return {
                success: true,
                data: result.rows
            }

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'PostModel.extractPostInformation';
            }
            throw err;
        }
    }

    async makePost({ id, categorySelected, postTitle, postContent, postImage }) {
        try {
            let query = `
                    INSERT INTO posts (user_id, title, content, image_url , category)
                    VALUES ($1, $2, $3, $4, $5)
                    RETURNING id;
                `;

            let values = [id, postTitle, postContent, postImage, categorySelected];

            let result = await pool.query(query, values);

            return (result.rowCount === 0) ? { success: false, reason: "Couldnt put in post" } : { success: true, data: result.rows[0] }

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'PostModel.makePost';
            }
            throw err;
        }
    }

}


module.exports = PostModel;