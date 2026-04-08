const mongoose = require("mongoose");

const orderSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
  products: [
    {
      name: String,
      price: Number,
      quantity: Number,
    },
  ],
  totalAmount: {
    type: Number,
    required: true,
  },
  status: {
    type: String,
    default: "Processing",
  },
  customerDetails: {
    name: String,
    phone: String,
    address: String,
  },
}, { timestamps: true });

module.exports = mongoose.model("Order", orderSchema);