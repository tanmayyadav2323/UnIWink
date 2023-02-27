const express = require("express");
const auth = require("../middlewares/auth");
const eventRouter = express.Router();
const Events = require("../models/event.model");

eventRouter.post('/api/create-event', auth, async (req, res) => {
    try {
        let event = new Events({
            id: req.body.id,
            title: req.body.title,
            authorId: req.body.authorId,
            memberIds: req.body.memberIds,
            creationDate: req.body.creationDate,
            about: req.body.about,
            image: req.body.image,
            images: req.body.images,
            rating: req.body.rating,
            startDateTime: req.body.startDateTime,
            endDateTime: req.body.endDateTime
          });
        event = event.save();
        req.json(event);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});


module.exports = eventRouter;