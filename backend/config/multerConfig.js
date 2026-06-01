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

// multerConfig.js

const multer = require("multer");
const path = require("path");
const fs = require("fs");


// Upload Directories


const uploadDirectories = {
  images: "uploads/images",
  documents: "uploads/documents",
  profiles: "uploads/profiles",
  temp: "uploads/temp",
};

// Create directories if they don't exist
Object.values(uploadDirectories).forEach((directory) => {
  if (!fs.existsSync(directory)) {
    fs.mkdirSync(directory, { recursive: true });
  }
});


const imageTypes = [
  "image/jpeg",
  "image/jpg",
  "image/png",
  "image/webp",
];

const documentTypes = [
  "application/pdf",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
];

const allowedTypes = [...imageTypes, ...documentTypes];



const fileFilter = (req, file, cb) => {
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(
      new Error(
        "Invalid file type. Only images and documents are allowed."
      ),
      false
    );
  }
};



const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    if (imageTypes.includes(file.mimetype)) {
      cb(null, uploadDirectories.images);
    } else if (documentTypes.includes(file.mimetype)) {
      cb(null, uploadDirectories.documents);
    } else {
      cb(null, uploadDirectories.temp);
    }
  },

  filename: (req, file, cb) => {
    const uniqueName =
      Date.now() +
      "-" +
      Math.round(Math.random() * 1e9);

    cb(
      null,
      uniqueName + path.extname(file.originalname)
    );
  },
});


const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10 MB
    files: 5,
  },
});



const profileStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDirectories.profiles);
  },

  filename: (req, file, cb) => {
    const userId = req.user?.id || "guest";

    cb(
      null,
      `profile-${userId}-${Date.now()}${path.extname(
        file.originalname
      )}`
    );
  },
});

const profileUpload = multer({
  storage: profileStorage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
});



const memoryUpload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
});



const deleteFile = async (filePath) => {
  try {
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
      return true;
    }

    return false;
  } catch (error) {
    console.error("Delete file error:", error);
    return false;
  }
};

const fileExists = (filePath) => {
  return fs.existsSync(filePath);
};

const getFileExtension = (filename) => {
  return path.extname(filename);
};

const getFileName = (filePath) => {
  return path.basename(filePath);
};

const getFileSizeInMB = (bytes) => {
  return (bytes / (1024 * 1024)).toFixed(2);
};



const getUploadStats = () => {
  try {
    const stats = {};

    Object.entries(uploadDirectories).forEach(
      ([key, directory]) => {
        if (fs.existsSync(directory)) {
          stats[key] = fs.readdirSync(directory).length;
        } else {
          stats[key] = 0;
        }
      }
    );

    return stats;
  } catch (error) {
    console.error("Stats error:", error);
    return {};
  }
};



const isImage = (file) => {
  return imageTypes.includes(file.mimetype);
};

const isDocument = (file) => {
  return documentTypes.includes(file.mimetype);
};

const validateImageSize = (file, maxSizeMB = 5) => {
  const maxSize = maxSizeMB * 1024 * 1024;

  return file.size <= maxSize;
};



module.exports = {
  upload,
  profileUpload,
  memoryUpload,
  deleteFile,
  fileExists,
  getFileExtension,
  getFileName,
  getFileSizeInMB,
  getUploadStats,
  isImage,
  isDocument,
  validateImageSize,
  uploadDirectories,
};
module.exports = upload;