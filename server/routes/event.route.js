const express = require("express");
const auth = require("../middlewares/auth");
const eventRouter = express.Router();
const Events = require("../models/event.model");
const UserEvents = require("../models/user.events");

eventRouter.post('/api/create-event', auth, async (req, res) => {
    try {
        const memberIds =[];
        let event = new Events({
            id: req.body.id,
            title: req.body.title,
            authorId: req.body.authorId,
            memberIds: memberIds,
            creationDate: req.body.creationDate,
            about: req.body.about,
            image: req.body.image,
            images: req.body.images,
            rating: req.body.rating,
            startDateTime: req.body.startDateTime,
            endDateTime: req.body.endDateTime
        });
        await event.save();

        let updatedEvent = await joinEvent(event.id, req.body.authorId);

        res.json(updatedEvent);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});


eventRouter.get('/api/all-events', auth, async (req, res) => {
    try {
        const events = await Events.find({}).sort({ endDateTime: 1 });
        res.json(events);
    }
    catch (e) {

        res.status(500).json({ error: e.message });
    }
});

eventRouter.get('/api/my-events', auth, async (req, res) => {
    try {
        const events = await Events.find({}).sort({ endDateTime: 1 });
        res.json(events);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});

eventRouter.post('/api/join-event', auth, async (req, res) => {
    try {
        const { eventId, userId } = req.body;

        const updatedEvent = await joinEvent(eventId, userId);

        res.json(updatedEvent);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});


async function joinEvent(eventId, userId) {
    try {
        let updatedEvent = await Events.findById(eventId);
        updatedEvent.memberIds.push(userId);

        let userEvents = await UserEvents.findById(userId);
        if (!userEvents) {
            userEvents = await UserEvents.create({
                id: userId,
                eventIds: [eventId]
            });
        } else {
            userEvents.eventIds.push(eventId);
        }

        await updatedEvent.save();
        await userEvents.save();
        return updatedEvent;
    } catch (e) {
        throw new Error(e.message);
    }
}

module.exports = eventRouter;