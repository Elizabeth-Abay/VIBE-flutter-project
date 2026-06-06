const PostModel = require('../model/postModel');
const PostModelG = require('../model/postModelG');



const postModel = new PostModel();
const postModelG = new PostModelG();


class PostService {
    async getPostsInACategory(categorySelected) {
        try {
            // get ids from the graph and content from postgres
            let result = await postModelG.selectPostsBasedOnCategory(categorySelected);

            //console.log(result);

            if (result?.data.length === 0) return result;

            // else have the posts information be extracted from the postgres
            let { data } = result;


            let resultSent = await postModel.extractPostInformation(data);

            return resultSent;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'PostService.getPostsInACategory';
            }
            throw err;
        }
    }


    async createPost({ id, categorySelected, postTitle, postContent, postImage }) {
        try {

            // putting the information in postgres table and link to graph
            // one post many categories in that case we uw

            let postIn = await postModel.makePost({ id, categorySelected, postTitle, postContent, postImage });


            // and then create a link in the graph db

            if (!postIn.success) return postIn;


            let linkingPost = await postModelG.linkPostWithCategory({ postId: postIn.data.id, category: categorySelected });

            return linkingPost;

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'PostService.createPost';
            }
            throw err;
        }
    }
}


module.exports = PostService;