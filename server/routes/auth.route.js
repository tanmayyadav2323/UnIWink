const express = require("express");
const authRouter = express.Router();
const User = require("../models/user.model");
const checkAuth = require("../middlewares/checkAuth");
const checkAdmin = require("../middlewares/checkAdmin");

const {
  fetchCurrentUser,
  loginWithPhoneOtp,
  createNewUser,
  verifyPhoneOtp,
  handleAdmin
} = require("../controllers/auth.controller");
const { generateOTP, fast2sms } = require("../utils/otp.util");
const { createJwtToken } = require("../utils/token.util");
const auth = require("../middlewares/auth");


authRouter.post("/register", createNewUser);

authRouter.post("/login_with_phone", loginWithPhoneOtp);

authRouter.post("/verify", verifyPhoneOtp);

authRouter.get("/me", checkAuth, fetchCurrentUser);

authRouter.get("/admin", checkAuth, checkAdmin, handleAdmin);



authRouter.post("/api/authenticatePhone", async (req, res, next) => {
  try {
    const { phone } = req.body;

    const user = await User.findOne({ phone });

    if (user) {
      const otp = generateOTP(6);
      user.phoneOtp = otp;
      user.isAccountVerified = true;
      await user.save();
      res.status(200).json({
        type: "success",
        message: "OTP sent",
        data: {
          userId: user._id,
        },
      });
    }
    else {
      const createUser = new User({
        phone,
        role: phone === process.env.ADMIN_PHONE ? "ADMIN" : "USER"
      });

      const user = await createUser.save();

      res.status(200).json({
        type: "success",
        message: "Account created OTP sended to mobile number",
        data: {
          userId: user._id,
        },
      });

      const otp = generateOTP(6);
      user.phoneOtp = otp;
      await user.save();

    }
    await fast2sms(
      {
        message: `Your OTP is ${otp}`,
        contactNumber: user.phone,
      },
      next
    );
  }
  catch (e) {
    res.status(500).json({ error: e.message });
  };
});



authRouter.post("/api/verifyPhone", async (req, res) => {
  try {
    const { otp, userId } = req.body;
    const user = await User.findById(userId);

    if (!user) {
      res.status(400).json({ error: "User not found" });
      return;
    }

    if (user.phoneOtp != otp) {
      res.status(400).json({ error: "Incorrect Otp" });
      return;
    }


    const token = jwt.sign({ id: user._id }, "passwordKey");
    user.phoneOtp = "";
    await user.save();

    res.status(201).json({
      type: "success",
      message: "OTP verified successfully",
      data: {
        token,
        userId: user._id
      }
    });
  }
  catch (e) {
    res.status(500).json({ error: e.message });
  }
});


authRouter.post("/tokenIsValid",async(req,res)=>{
  try{
    const token = req.header('x-auth-token');
    if(!token)return res.json(false);
    const verified = jwt.verify(token,"passwordKey");
    if(!verified)return res.json(false);

    const user = await User.findById(verified.id);
    if(!user)return res.json(false);
    return res.json(true);
  }
  catch(e){
    res.status(500).json({ error: e.message });
  }
});

//get user data
authRouter.get('/',auth,async(req,res)=>{
  const user = await User.findById(req.user);
  res.json({...user._doc,token:req.token});
});

module.exports = authRouter;