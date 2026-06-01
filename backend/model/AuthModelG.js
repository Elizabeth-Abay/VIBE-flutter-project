const driver = require('../config/neo4jConfig');


class AuthModelGraph {
    async createGraphNode(id) {

        const session = driver.session();

        const sessionToWrite = driver.session({
            defaultAccessMode: session.WRITE
        })

        try {
            // create a node
            let result = await sessionToWrite.executeWrite(
                tx => {
                    return tx.run(
                        `CREATE (n:Person { id : $id }) RETURN n`,
                        {
                            id
                        }
                    )
                }
            )

            let res = result.records[0]?.length;

            return (res === 0) ?
                {
                    success: false,
                    reason: "Couldnt create the node"

                }
                :
                {
                    success: true
                }


            return
        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'AuthModelGraph.createGraphNode';
            }
            throw err;
        }

    }
}


module.exports = AuthModelGraph;
