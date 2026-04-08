const express = require("express");
const router = express.Router();

const Order = require("../models/Order");
const sendEmailToAdmin = require("../utils/mailer");

// ==============================
// 📦 CREATE ORDER
// ==============================
router.post("/create", async (req, res) => {
  try {
    const { userId, products, totalAmount, customerDetails } = req.body;

    if (!userId || !products || !totalAmount || !customerDetails) {
      return res.status(400).json({
        success: false,
        message: "Missing fields",
      });
    }

    const order = new Order({
      userId,
      products,
      totalAmount,
      customerDetails,
    });

    await order.save();

    // 🔥 SEND EMAIL
    sendEmailToAdmin(order);

    res.json({
      success: true,
      message: "Order placed successfully ✅",
      order,
    });

  } catch (err) {
    console.log(err);
    res.status(500).json({
      success: false,
      message: "Order failed",
    });
  }
});

// ==============================
// 📦 USER ORDERS
// ==============================
router.get("/:userId", async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.params.userId })
      .sort({ createdAt: -1 });

    res.json(orders);
  } catch (err) {
    res.status(500).json({ message: "Error fetching orders" });
  }
});

// ==============================
// 📍 TRACK ORDER
// ==============================
router.get("/track/:orderId", async (req, res) => {
  try {
    const order = await Order.findById(req.params.orderId);

    if (!order) {
      return res.status(404).json({ message: "Order not found" });
    }

    res.json(order);
  } catch (err) {
    res.status(500).json({ message: "Tracking failed" });
  }
});

// ==============================
// 🔄 UPDATE ORDER (ADMIN)
// ==============================
router.put("/update", async (req, res) => {
  try {
    const { orderId, status } = req.body;

    await Order.findByIdAndUpdate(orderId, { status });

    res.json({
      success: true,
      message: "Order updated",
    });

  } catch (err) {
    res.status(500).json({ message: "Update failed" });
  }
});

module.exports = router;