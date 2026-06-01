const driver = require('../config/neo4jConfig');


class InterestModelG {
    async linkingUserWithInterests(sentInfo) {
        const session = driver.session();

        const sessionToWrite = driver.session({
            defaultAccessMode: session.WRITE
        });

        // console.log(sentInfo);

        try {
            // query - interests = [ { name , rated_as }]
            // then u will have it unwind - ie separate the object 
            // interest - will be the current item
            const query = `
                MATCH (n:Person {id: $id})
                UNWIND $interests AS interest
                MATCH (i:Interest{slug: interest.name})
                MERGE (n)-[r:INTERESTED_IN ]->(i)
                SET r.rated_as = interest.rated_as
                RETURN n, collect(r) AS relationships
            `;
            // since interests is an array of objects
            // unwind will run the query below it once for every object termed as interest


            let result = await sessionToWrite.executeWrite(
                tx => {
                    return tx.run(
                        query, sentInfo
                    )
                }

            )

            console.log("Result from connecting interest and user ", result.records);


            return (result.records[0]?.length === 0) ? { success: false } : { success: true }


        } catch (err) {
            err.from = 'InterestModelG.linkingUserWithInterests';
            throw err;
        }
    }

    async deletingLinks(sentInfo) {
        const session = driver.session();

        const sessionToWrite = driver.session({
            defaultAccessMode: session.WRITE
        })

        try {

            let queryToDel = `
            MATCH (n:Person) WHERE n.id = $id
            MATCH (n)-[r:INTERESTED_IN]->()
            DELETE r
            RETURN n
            `

            let delRes = await sessionToWrite.executeWrite(
                tx => {
                    return tx.run(
                        queryToDel, sentInfo
                    )

                }
            )

            return (delRes.records[0]?.length === 0) ? {
                success: false,
                reason: "Database issue while deleting old interest links"
            } : {
                success: true
            }


        } catch (err) {
            err.from = 'InterestModelG.deletingLinks';
            throw err;
        }
    }

    async updatingLinksOfInterests(sentInfo) {
        try {
            // sentInfo = { id , interests : [ { name , rated_as }]}
            // first delete all the links then recreate them


            let deleting = await this.deletingLinks(sentInfo);

            if (!deleting.success) return deleting;

            let res = await this.linkingUserWithInterests(sentInfo);

            return res;

        } catch (err) {
            err.from = 'InterestModelG.updaatingLinksOfInterests';
            throw err;
        }
    }

    async gettingAllInterest(id) {
        const session = driver.session();

        const sessionToRead = driver.session({
            defaultAccessMode: session.READ
        })

        try {
            // we want to get all names of nodes which are linked by interested_in
            let query = `
                    MATCH (u:Person {id: $id})-[r:INTERESTED_IN]->(i)
                    RETURN collect(distinct {interest: i.name, rating: r.rated_as}) AS interests
            `

            let res = await sessionToRead.executeRead(
                tx => {
                    return tx.run(
                        query, { id }
                    )
                }
            )

            // res.records[0]._fields this is an array made up of 2 arrays 
            // the front end only needs the [{ name , rated_as}]
            // so loop through both arrays in the service layer  

            return (res.records[0].length === 0) ? { success: false } : {
                success: true,
                data: res.records[0]._fields
            }


        } catch (err) {
            err.from = 'InterestModelG.gettingAllInterest';
            throw err;
        }
    }
}


module.exports = InterestModelG;