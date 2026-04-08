const jwt = require("jsonwebtoken");

const adminAuth = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    // ❌ NO TOKEN
    if (!authHeader) {
      return res.status(401).json({
        success: false,
        message: "No token provided",
      });
    }

    // ✅ FORMAT: Bearer TOKEN
    const token = authHeader.split(" ")[1];

    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Invalid token format",
      });
    }

    // 🔐 VERIFY TOKEN (SAME SECRET)
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    console.log("✅ DECODED:", decoded);

    // 🔥 CHECK ADMIN
    if (!decoded.isAdmin) {
      return res.status(403).json({
        success: false,
        message: "Admin only",
      });
    }

    req.user = decoded;

    next();

  } catch (err) {
    console.log("❌ ADMIN AUTH ERROR:", err);

    return res.status(401).json({
      success: false,
      message: "Invalid or expired token",
    });
  }
};

module.exports = adminAuth;