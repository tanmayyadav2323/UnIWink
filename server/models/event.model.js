const {model, Schema} = require("mongoose");

const eventSchema = new Schema(
    {
        title:{
            type: String,
            required:true,

        },
        authorId:{
            type:String,
            required:true
        },
        memberIds: [String],
        creationDate: Date,
        about: String,
        image: String,
        images: [String],  
        rating: Number,
        startDateTime: Date,
        endDateTime: Date
    },
)

module.exports = model("Events", eventSchema);