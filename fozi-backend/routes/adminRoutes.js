const express = require("express");
const router = express.Router();

const adminAuth = require("../middleware/adminMiddleware");

const User = require("../models/User");
const Order = require("../models/Order");
const Product = require("../models/Product");

const jwt = require("jsonwebtoken");

// ==============================
// 🔐 ADMIN LOGIN (FINAL FIXED)
// ==============================

router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    // 🔥 ADMIN CREDENTIALS
    if (email !== "kdhanush484@gmail.com" || password !== "142612") {
      return res.status(401).json({
        success: false,
        message: "Invalid credentials",
      });
    }

    // ✅ SAME SECRET EVERYWHERE
    const token = jwt.sign(
      {
        isAdmin: true,
        email: email,
      },
      process.env.JWT_SECRET, // 🔥 MUST MATCH middleware
      { expiresIn: "7d" }
    );

    res.json({
      success: true,
      token,
    });

  } catch (err) {
    console.log("❌ ADMIN LOGIN ERROR:", err);
    res.status(500).json({
      success: false,
      message: "Login failed",
    });
  }
});


// ==============================
// 📸 IMAGE UPLOAD (MULTER)
// ==============================

const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    const uniqueName = Date.now() + path.extname(file.originalname);
    cb(null, uniqueName);
  },
});

const fileFilter = (req, file, cb) => {
  const allowedTypes = /jpeg|jpg|png/;
  const ext = allowedTypes.test(
    path.extname(file.originalname).toLowerCase()
  );

  if (ext) cb(null, true);
  else cb(new Error("Only images allowed"));
};

const upload = multer({
  storage,
  fileFilter,
});

// ==============================
// 📊 ADMIN STATS
// ==============================

router.get("/stats", adminAuth, async (req, res) => {
  try {
    const totalUsers = await User.countDocuments();
    const totalOrders = await Order.countDocuments();
    const totalProducts = await Product.countDocuments();

    const orders = await Order.find();

    let totalRevenue = 0;
    const salesData = [];

    orders.forEach((order, index) => {
      const amount = order.totalAmount || 0;
      totalRevenue += amount;

      salesData.push({
        x: index + 1,
        y: amount,
      });
    });

    res.json({
      success: true,
      stats: {
        users: totalUsers,
        orders: totalOrders,
        products: totalProducts,
        revenue: totalRevenue,
        salesData,
      },
    });

  } catch (err) {
    console.log("❌ STATS ERROR:", err);
    res.status(500).json({
      success: false,
      message: "Stats error",
    });
  }
});

// ==============================
// ➕ ADD PRODUCT
// ==============================

router.post(
  "/product",
  adminAuth,
  upload.single("image"),
  async (req, res) => {
    try {
      console.log("BODY:", req.body);
      console.log("FILE:", req.file);

      const { name, price } = req.body;

      if (!name || !price || !req.file) {
        return res.status(400).json({
          success: false,
          message: "All fields + image required",
        });
      }

      const imageUrl = `${req.protocol}://${req.get("host")}/uploads/${req.file.filename}`;

      const product = new Product({
        name,
        price: Number(price),
        image: imageUrl,
      });

      await product.save();

      res.status(200).json({
        success: true,
        message: "Product added successfully",
        product,
      });

    } catch (err) {
      console.log("❌ ADD PRODUCT ERROR:", err);
      res.status(500).json({
        success: false,
        message: err.message || "Upload failed",
      });
    }
  }
);

// ==============================
// 📦 GET PRODUCTS
// ==============================

router.get("/products", adminAuth, async (req, res) => {
  try {
    const products = await Product.find().sort({ createdAt: -1 });

    res.json({
      success: true,
      products,
    });

  } catch (err) {
    console.log("❌ PRODUCT ERROR:", err);
    res.status(500).json({
      success: false,
      message: "Fetch failed",
    });
  }
});

// ==============================
// ❌ DELETE PRODUCT
// ==============================

router.delete("/product/:id", adminAuth, async (req, res) => {
  try {
    await Product.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: "Deleted",
    });

  } catch (err) {
    console.log("❌ DELETE ERROR:", err);
    res.status(500).json({
      success: false,
      message: "Delete failed",
    });
  }
});

// ==============================
// ✏️ UPDATE PRODUCT
// ==============================

router.put("/product/:id", adminAuth, async (req, res) => {
  try {
    const updated = await Product.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );

    res.json({
      success: true,
      product: updated,
    });

  } catch (err) {
    console.log("❌ UPDATE ERROR:", err);
    res.status(500).json({
      success: false,
      message: "Update failed",
    });
  }
});

// ==============================
// 📦 ORDERS
// ==============================

router.get("/orders", adminAuth, async (req, res) => {
  try {
    const orders = await Order.find()
      .populate("userId", "name email")
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      orders,
    });

  } catch (err) {
    console.log("❌ ORDERS ERROR:", err);
    res.status(500).json({
      success: false,
      message: "Orders failed",
    });
  }
});

// ==============================
// 👤 USERS
// ==============================

router.get("/users", adminAuth, async (req, res) => {
  try {
    const users = await User.find().select("-password");

    res.json({
      success: true,
      users,
    });

  } catch (err) {
    console.log("❌ USERS ERROR:", err);
    res.status(500).json({
      success: false,
      message: "Users failed",
    });
  }
});

// ==============================
// 🔄 UPDATE ORDER
// ==============================

router.put("/update-order", adminAuth, async (req, res) => {
  try {
    const { orderId, status } = req.body;

    const order = await Order.findByIdAndUpdate(
      orderId,
      { status },
      { new: true }
    );

    res.json({
      success: true,
      order,
    });

  } catch (err) {
    console.log("❌ UPDATE ERROR:", err);
    res.status(500).json({
      success: false,
      message: "Update failed",
    });
  }
});

// ==============================
// 🧪 TEST
// ==============================

router.get("/test", (req, res) => {
  res.send("ADMIN ROUTES WORKING ✅");
});

module.exports = router;