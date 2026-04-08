const razorpay = require("../config/razorpay");
const crypto = require("crypto");
const Order = require("../models/Order");

// CREATE PAYMENT
exports.createPayment = async (req, res) => {
  try {
    const { amount } = req.body;

    const options = {
      amount: amount * 100,
      currency: "INR",
      receipt: "receipt_" + Date.now()
    };

    const order = await razorpay.orders.create(options);

    res.json(order);

  } catch (error) {
    console.error("CREATE PAYMENT ERROR:", error);
    res.status(500).json({ error: "Payment creation failed" });
  }
};

// VERIFY PAYMENT
exports.verifyPayment = async (req, res) => {
  try {
    const {
      razorpay_order_id,
      razorpay_payment_id,
      razorpay_signature,
      userId,
      items,
      totalAmount
    } = req.body;

    const body = razorpay_order_id + "|" + razorpay_payment_id;

    const expectedSignature = crypto
      .createHmac("sha256", process.env.RAZORPAY_SECRET)
      .update(body)
      .digest("hex");

    if (expectedSignature === razorpay_signature) {

      const order = new Order({
        userId,
        items,
        totalAmount,
        status: "Paid"
      });

      await order.save();

      res.json({ success: true });

    } else {
      res.status(400).json({ success: false });
    }

  } catch (error) {
    console.error("VERIFY PAYMENT ERROR:", error);
    res.status(500).json({ error: "Verification failed" });
  }
};