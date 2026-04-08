const express = require("express");
const router = express.Router();

const axios = require("axios");
const jwt = require("jsonwebtoken");

const User = require("../models/User");

// 🔥 ADMIN EMAIL
const ADMIN_EMAIL = "kdhanush484@gamil.com";

/// 🔥 GOOGLE LOGIN (WEB FIXED)
router.post("/google", async (req, res) => {
  try {
    const { access_token } = req.body;

    // 🔥 GET USER FROM GOOGLE
    const response = await axios.get(
      "https://www.googleapis.com/oauth2/v3/userinfo",
      {
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      }
    );

    const { email, name, picture } = response.data;

    // 🔍 CHECK USER
    let user = await User.findOne({ email });

    if (!user) {
      user = await User.create({
        name,
        email,
        picture,
        isAdmin: email === ADMIN_EMAIL, // 🔥 ADMIN SET
      });
    } else {
      user.isAdmin = email === ADMIN_EMAIL;
      await user.save();
    }

    // 🔐 JWT
    const token = jwt.sign(
      { id: user._id },
      "SECRET_KEY",
      { expiresIn: "7d" }
    );

    res.json({
      success: true,
      user,
      token,
    });

  } catch (err) {
    console.log("Google Auth Error:", err);

    res.status(400).json({
      success: false,
      message: "Google Auth Failed",
    });
  }
});

/// 🔐 EMAIL LOGIN
router.post("/login", async (req, res) => {
  try {
    const { email } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({
        success: false,
        message: "User not found",
      });
    }

    const token = jwt.sign(
      { id: user._id },
      "SECRET_KEY",
      { expiresIn: "7d" }
    );

    res.json({
      success: true,
      user,
      token,
    });

  } catch (err) {
    console.log(err);
    res.status(500).json({ success: false });
  }
});

module.exports = router;