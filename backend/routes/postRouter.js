const express = require('express');
const TokenDecoder = require('../middleware/tokenDecoder');
const PostController = require('../controller/PostController');
const PostSchemas = require('../schemas/PostSchemas');
const validateCategory = require('../middleware/joiValidatorParams');
const validate = require('../middleware/joiValidator');
const uploads = require('../config/multerConfig');

const postRouter = express.Router();
const postController = new PostController();


// -- works
postRouter.get('/get-post-given-category/:categorySelected', TokenDecoder.accessDecode, validateCategory(PostSchemas.getPostCategory), postController.getPostsInACategory);

// -- works
postRouter.post('/make-post', TokenDecoder.accessDecode, uploads.single('postPic') , postController.makeAPost);


module.exports = postRouter;