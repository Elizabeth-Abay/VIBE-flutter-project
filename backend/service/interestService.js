const InterestModelG = require('../model/interestModelGraph');


const interestModelG = new InterestModelG();

class InterestService {
    async linkingInterest({ id, interestedIn }) {
        try {
            // linking
            // sentInfo = { id , interestedIn : { name : value }}
            // convert that to interests : [ { name : something , value : Number(value)}]

            //console.log("interestedIn ", interestedIn);

            let interests = [];


            for (let interest of interestedIn) {
                // interest is the key;
                // //console.log(interest) -- gives the index in for in

                let key = Object.keys(interest)[0];
                let val = Object.values(interest);;

                let Obj = {
                    name: key.toLowerCase(),
                    rated_as: Number(val)
                }


                interests.push(Obj)
            }

            //console.log("interests reorganized " , interests);

            let result = await interestModelG.linkingUserWithInterests({ id, interests });

            //console.log("Result of linking intersts " , result);

            return (result.success) ? { success: true } : {
                success: false,
                reason: "data base problem from linkingInterest"

            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'InterestService.linkingInterest';
            }
            throw err;
        }

    }


    async updatingLinksOfInterests({ id, interestedIn }) {
        try {
            // linking
            // sentInfo = { userId , interestedIn : { name : value }}
            // convert that to interests : [ { name : something , value : Number(value)}]

            let interests = [];

            for (let interest of interestedIn) {
                // interest is the key;
                // //console.log(interest) -- gives the index in for in

                let key = Object.keys(interest)[0];
                let val = Object.values(interest);;

                let Obj = {
                    name: key.toLowerCase(),
                    rated_as: Number(val)
                }

                // console.log(Obj)

                interests.push(Obj)
            }


            console.log(interests);

            let result = await interestModelG.updatingLinksOfInterests({ id, interests });

            return (result.success) ? { success: true } : {
                success: false,
                reason: "data base problem from linkingInterest"

            }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'InterestService.linkingInterest';
            }
            throw err;
        }

    }


    async getUserInterest(id) {
        try {

            let result = await interestModelG.gettingAllInterest(id);

            // if successful this retuns 2 arrays
            if (!result.success) return result;

            //console.log("Resukt ", result)

            const interestAndVals = result.data[0];



            const formattedInterests = interestAndVals.map((item) => {
                // Lowercase and trim the interest name (e.g., "Football" -> "football")
                const key = item.interest.toLowerCase().trim();
                const val = item.rating;

                return { [key]: val };
            });



            return { success: true, data: formattedInterests }

        } catch (err) {
            // the lower layers will throw error and the upper layer will be the one to catch that
            if (typeof err === 'object' && !err.from) {
                err.from = 'InterestService.getUserInterest';
            }
            throw err;
        }

    }
}





module.exports = InterestService;