const Product = require("../models/Product");
const Order = require("../models/Order");

exports.createOrder = async (req, res) => {
  try {
    const { userId, products, totalAmount, paymentMethod, customerDetails } = req.body;

    // 🔥 REDUCE STOCK
    for (let item of products) {
      const product = await Product.findById(item.productId);

      if (!product) {
        return res.status(404).json({ msg: "Product not found" });
      }

      if (product.stock < item.quantity) {
        return res.status(400).json({ msg: "Out of stock" });
      }

      product.stock -= item.quantity;
      await product.save();
    }

    // 🔥 CREATE ORDER
    const order = new Order({
      userId,
      products,
      totalAmount,
      paymentStatus: paymentMethod === "COD" ? "Pending" : "Paid",
      orderStatus: "Processing",
      customerDetails
    });

    await order.save();

    res.json(order);

  } catch (err) {
    console.log(err);
    res.status(500).json({ msg: "Server error" });
  }
};