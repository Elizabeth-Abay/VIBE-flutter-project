const dotenv = require('dotenv');
const nodeMailer = require('nodemailer')

const emailTransporter = nodeMailer.createTransport({
    host: 'smtp.gmail.com', // means the emails i send live here 
    port: 587, // use this port to send out the emails
    secure: false,
    auth: {
        user: process.env.EMAIL,
        pass: process.env.EMAIL_PASSWORD 
        // is the password for the app to be able to send 
        // emails through the provided email not ur actual email password
    },
    tls: { rejectUnauthorized: false } // bypass certificate validation  for development only reverse this once through dev't
})

// emailTransporter.js

const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: process.env.EMAIL_SERVICE || "gmail",
  host: process.env.EMAIL_HOST,
  port: process.env.EMAIL_PORT || 587,
  secure: false,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASSWORD,
  },
});

async function verifyConnection() {
  try {
    await transporter.verify();
    console.log("Email server connection established.");
    return true;
  } catch (error) {
    console.error("Email server connection failed:", error.message);
    return false;
  }
}

function createEmailTemplate({
  title,
  username,
  message,
  buttonText,
  buttonLink,
}) {
  return `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto;">
      <h2 style="color:#333;">${title}</h2>

      <p>Hello ${username || "User"},</p>

      <p>${message}</p>

      ${
        buttonLink
          ? `
        <a
          href="${buttonLink}"
          style="
            display:inline-block;
            padding:12px 20px;
            background:#007bff;
            color:white;
            text-decoration:none;
            border-radius:5px;
            margin-top:10px;
          "
        >
          ${buttonText || "Open Link"}
        </a>
      `
          : ""
      }

      <hr style="margin-top:30px;" />

      <p style="font-size:12px;color:#888;">
        This email was generated automatically.
      </p>
    </div>
  `;
}

async function sendEmail({
  to,
  subject,
  html,
  text,
  attachments = [],
}) {
  try {
    const mailOptions = {
      from: process.env.EMAIL_FROM,
      to,
      subject,
      text,
      html,
      attachments,
    };

    const result = await transporter.sendMail(mailOptions);

    console.log("Email sent successfully:", result.messageId);

    return {
      success: true,
      messageId: result.messageId,
    };
  } catch (error) {
    console.error("Email sending failed:", error);

    return {
      success: false,
      error: error.message,
    };
  }
}

async function sendWelcomeEmail(email, username) {
  return sendEmail({
    to: email,
    subject: "Welcome to Our Platform",
    html: createEmailTemplate({
      title: "Welcome",
      username,
      message:
        "Thank you for creating an account. We are excited to have you with us.",
      buttonText: "Get Started",
      buttonLink: process.env.CLIENT_URL,
    }),
  });
}

async function sendPasswordResetEmail(email, username, resetLink) {
  return sendEmail({
    to: email,
    subject: "Reset Your Password",
    html: createEmailTemplate({
      title: "Password Reset",
      username,
      message:
        "We received a request to reset your password. Click the button below.",
      buttonText: "Reset Password",
      buttonLink: resetLink,
    }),
  });
}

async function sendVerificationEmail(email, username, verificationLink) {
  return sendEmail({
    to: email,
    subject: "Verify Your Account",
    html: createEmailTemplate({
      title: "Email Verification",
      username,
      message:
        "Please verify your email address to activate your account.",
      buttonText: "Verify Account",
      buttonLink: verificationLink,
    }),
  });
}

async function sendAdminNotification(subject, message) {
  return sendEmail({
    to: process.env.ADMIN_EMAIL,
    subject,
    html: `
      <h3>Admin Notification</h3>
      <p>${message}</p>
    `,
  });
}

async function sendBulkEmails(recipients, subject, htmlContent) {
  const results = [];

  for (const recipient of recipients) {
    const result = await sendEmail({
      to: recipient,
      subject,
      html: htmlContent,
    });

    results.push({
      email: recipient,
      success: result.success,
    });
  }

  return results;
}

module.exports = {
  transporter,
  verifyConnection,
  createEmailTemplate,
  sendEmail,
  sendWelcomeEmail,
  sendPasswordResetEmail,
  sendVerificationEmail,
  sendAdminNotification,
  sendBulkEmails,
};

module.exports = emailTransporter