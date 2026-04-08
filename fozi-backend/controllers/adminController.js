const Order = require("../models/Order");

// UPDATE ORDER STATUS
exports.updateOrderStatus = async (req, res) => {

  const { orderId, status } = req.body;

  try {
    const order = await Order.findByIdAndUpdate(
      orderId,
      { status },
      { new: true }
    );

    res.json(order);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};