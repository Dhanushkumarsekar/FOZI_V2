const express = require("express");
const router = express.Router();

const {
  addToCart,
  getCart,
  removeFromCart
} = require("../controllers/cartController");

router.post("/cart/add", addToCart);
router.get("/cart/:userId", getCart);
router.post("/cart/remove", removeFromCart);

module.exports = router;