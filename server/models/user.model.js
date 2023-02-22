
const { model, Schema } = require("mongoose");

const userSchema = new Schema(
  {

    phone: {
      type: String,
      required: true,
      trim: true,
      unique: true,
    },

    role: {
      type: String,
      enum: ["ADMIN", "USER"],
      default: "USER",
    },

    des: String,
    phoneOtp: String,
    gender: String,
    imageUrl: String,

  },
  { timestamps: true }
);

module.exports = model("User", userSchema);