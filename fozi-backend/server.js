require("dotenv").config();

const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();

console.log("🔥 SERVER FILE LOADED");

// ==============================
// 🔥 MIDDLEWARE
// ==============================

app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "PUT", "DELETE"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));

app.use(express.json());

// 🔥 STATIC IMAGE SERVE (VERY IMPORTANT)
app.use("/uploads", express.static("uploads"));

// ==============================
// 🔥 DATABASE
// ==============================

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("✅ MongoDB Connected"))
  .catch(err => console.log("❌ DB ERROR:", err));

// ==============================
// 🔥 ROUTES
// ==============================

app.use("/api/auth", require("./routes/auth"));
app.use("/api/products", require("./routes/productRoutes"));
app.use("/api/cart", require("./routes/cartRoutes"));
app.use("/api/orders", require("./routes/orderRoutes"));
app.use("/api/payment", require("./routes/paymentRoutes"));
app.use("/api/admin", require("./routes/adminRoutes"));

console.log("🔥 ROUTES CONNECTED");

// ==============================
// TEST
// ==============================

app.get("/", (req, res) => {
  res.send("🚀 FOZI Backend Running...");
});

// ==============================
// START SERVER
// ==============================

const PORT = process.env.PORT || 5000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running on ${PORT}`);
});