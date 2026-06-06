const multer = require('multer');
const path = require('path');
const fs = require('fs');

// 1. Ensure the upload directory exists so your app doesn't crash
const uploadDir = 'uploads/';
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// 2. Configure Disk Storage
const storage = multer.diskStorage({
    // Tells multer WHERE to save the file
    destination: function (req, file, cb) {
        cb(null, uploadDir);
    },
    // Tells multer WHAT to name the file (prevents overwriting files with the same name)
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        // Keeps original extension (e.g., .jpg, .png)
        const fileExtension = path.extname(file.originalname);
        cb(null, file.fieldname + '-' + uniqueSuffix + fileExtension);
    }
});

// 3. Optional: Filter files to make sure they are actually images
const fileFilter = (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif|webp/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);

    if (extname && mimetype) {
        return cb(null, true);
    } else {
        cb(new Error('Only images (.jpg, .jpeg, .png, .gif, .webp) are allowed!'));
    }
};

// 4. Initialize upload middleware with limits and disk storage
const upload = multer({
    storage: storage,
    limits: { fileSize: 5 * 1024 * 1024 }, // 5 MB maximum
    fileFilter: fileFilter
});


module.exports = upload;