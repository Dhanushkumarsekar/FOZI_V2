// ================= IMPORTS =================
const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const User = require("../models/auth");

// ================= ADMIN LOGIN =================
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    console.log("📥 LOGIN REQUEST:", email, password);

    // 🔍 FIND USER
    const user = await User.findOne({ email });

    console.log("📦 DB USER:", user);

    // ❌ USER NOT FOUND
    if (!user) {
      return res.status(401).json({
        success: false,
        message: "User not found",
      });
    }

    // ❌ NOT ADMIN
    if (!user.isAdmin) {
      return res.status(403).json({
        success: false,
        message: "Access denied (Not Admin)",
      });
    }

    // 🔥 DEBUG PASSWORD CHECK
    console.log("Entered Password:", `"${password}"`);
    console.log("DB Password:", `"${user.password}"`);
    console.log("Length Entered:", password.length);
    console.log("Length DB:", user.password.length);
    console.log("Match:", password === user.password);

    // 🔐 PASSWORD CHECK (FIXED)
    if (password.trim() !== String(user.password).trim()) {
      return res.status(401).json({
        success: false,
        message: "Invalid credentials",
      });
    }

    // 🔐 GENERATE TOKEN
    const token = jwt.sign(
      {
        id: user._id,
        email: user.email,
        isAdmin: user.isAdmin,
      },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    // ✅ SUCCESS RESPONSE
    res.json({
      success: true,
      message: "Admin Login Success ✅",
      token,
      user,
    });

  } catch (err) {
    console.error("❌ ADMIN LOGIN ERROR:", err);

    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
});

// ================= EXPORT =================
module.exports = router;