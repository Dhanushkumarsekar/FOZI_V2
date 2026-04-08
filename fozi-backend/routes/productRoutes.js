const express = require('express');
const router = express.Router();

const {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
} = require('../controllers/productController');

// ==========================
// PUBLIC ROUTES (NO AUTH)
// ==========================

// GET all products
// POST create new product
router.route('/')
  .get(getProducts)
  .post(createProduct);

// GET single product by ID
// PUT update product
// DELETE product
router.route('/:id')
  .get(getProductById)
  .put(updateProduct)
  .delete(deleteProduct);

module.exports = router;