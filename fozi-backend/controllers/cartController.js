const Cart = require("../models/Cart");

// ADD TO CART
exports.addToCart = async (req, res) => {

  const { userId, productId, quantity } = req.body;

  let cart = await Cart.findOne({ userId });

  if (!cart) {
    cart = new Cart({ userId, items: [] });
  }

  const existingItem = cart.items.find(
    item => item.productId === productId
  );

  if (existingItem) {
    existingItem.quantity += quantity;
  } else {
    cart.items.push({ productId, quantity });
  }

  await cart.save();

  res.json(cart);
};

// GET CART
exports.getCart = async (req, res) => {

  const cart = await Cart.findOne({ userId: req.params.userId });

  res.json(cart);
};

// REMOVE ITEM
exports.removeFromCart = async (req, res) => {

  const { userId, productId } = req.body;

  const cart = await Cart.findOne({ userId });

  cart.items = cart.items.filter(
    item => item.productId !== productId
  );

  await cart.save();

  res.json(cart);
};