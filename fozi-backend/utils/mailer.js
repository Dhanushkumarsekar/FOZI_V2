const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.APP_PASSWORD,
  },
});

const sendEmailToAdmin = async (order) => {
  try {
    const mailOptions = {
      from: process.env.EMAIL,
      to: process.env.ADMIN_EMAIL,
      subject: "🛒 New Order Received",
      text: `
New Order Received!

Total: ₹${order.totalAmount}

Customer:
Name: ${order.customerDetails.name}
Phone: ${order.customerDetails.phone}
Address: ${order.customerDetails.address}

Products:
${order.products.map(p => `${p.name} x${p.quantity}`).join("\n")}
      `,
    };

    await transporter.sendMail(mailOptions);
    console.log("✅ Email sent");
  } catch (err) {
    console.log("❌ Email error:", err);
  }
};

module.exports = sendEmailToAdmin;