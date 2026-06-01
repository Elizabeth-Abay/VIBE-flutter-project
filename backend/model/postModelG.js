const driver = require('../config/neo4jConfig');


class PostModelG {
    async selectPostsBasedOnCategory(categorySelected) {
        const session = driver.session();

        const sessionToRead = driver.session({
            defaultAccessMode: session.READ
        });

        try {
            const query = `
                MATCH (p:Post)-[:BELONGS_TO]->(c:Interest{slug: $categorySelected})
                RETURN collect(p.id) AS postIds`;

            let result = await sessionToRead.executeRead(
                tx => {
                    return tx.run(
                        query, { categorySelected }
                    )
                }
            );

            // before extracting check
            if (result.records.length === 0) {
                return { success: true, data: [] };
            }


            const postIdsArray = result.records[0].get('postIds');

            return {
                success: true,
                data: postIdsArray
            }

        } catch (err) {
            err.from = 'PostModelG.selectPostsBasedOnCategory';
            throw err;
        }
    }


    async linkPostWithCategory({ postId, category }) {
        const session = driver.session();

        const sessionToWrite = driver.session({
            defaultAccessMode: session.WRITE
        });


        try {

            //  the postId is a singular id here and the slug is one too
            // meaning the post will have a single category
            const query = `
                MERGE (p:Post { id: $postId })
                WITH p
                MATCH (i:Interest {slug: $category })
                MERGE (p)-[:BELONGS_TO]->(i)
                RETURN p, i
            `;


            console.log('query ', query);

            console.log({ postId, category });

            let result = await sessionToWrite.executeWrite(
                tx => {
                    return tx.run(
                        query, { postId, category }
                    )
                }
            );



            return (result.records.length === 0) ? { success: false } : { success: true }

        } catch (err) {
            err.from = 'PostModelG.linkPostWithCategory';
            throw err;
        }
    }

}


module.exports = PostModelG;