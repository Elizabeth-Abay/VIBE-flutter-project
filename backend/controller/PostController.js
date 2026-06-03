const PostService = require('../service/postService');

const postService = new PostService();


class PostController {
    async getPostsInACategory(req, res, next) {
        try {
            let { categorySelected } = req.category;
            console.log("categorySelected " , categorySelected.toLowerCase());

            let result = await postService.getPostsInACategory(categorySelected.toLowerCase());

            return (result.success) ?
                res.status(200).json(result) : res.status(400).json({ message: 'bad request' })

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'PostController.getPostsInACategory';
            }
            next(err);
        }

    }

    async makeAPost(req, res, next) {
        try {
            let { id } = req.decodedAccess;


            // have req.files .. part
            let postImage = req.file ? req.file.path : null;


            let {
                categorySelected,
                postTitle,
                postContent
            } = req.body;

            let result = await postService.createPost({
                id,
                categorySelected,
                postTitle,
                postContent,
                postImage
            });


            return (result.success) ?
                res.status(200).json(result) : res.status(400).json({ message: 'Couldnt load post' });

        } catch (err) {
            if (typeof err === 'object' && !err.from) {
                // this is so that if lower layer's message won't be masked
                err.from = 'PostController.makeAPost';

            }
            next(err);
        }

    }
}



module.exports = PostController;