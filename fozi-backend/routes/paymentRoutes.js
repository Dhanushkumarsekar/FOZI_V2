const express = require("express");
const router = express.Router();

const {
  createPayment,
  verifyPayment
} = require("../controllers/paymentController");

router.post("/payment/create", createPayment);
router.post("/payment/verify", verifyPayment);

module.exports = router;