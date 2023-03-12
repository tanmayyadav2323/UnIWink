const express = require("express");
const auth = require("../middlewares/auth");
const eventRouter = express.Router();
const Events = require("../models/event.model");
const UserEvents = require("../models/user.events");

eventRouter.post('/api/create-event', auth, async (req, res) => {
    try {
        let event = new Events({
            id: req.body.id,
            title: req.body.title,
            authorId: req.body.authorId,
            memberIds: [],
            organizer: req.body.organizer,
            savedMembers: [],
            memberImageUrls: [],
            creationDate: req.body.creationDate,
            about: req.body.about,
            image: req.body.image,
            images: req.body.images,
            rating: req.body.rating,
            startDateTime: req.body.startDateTime,
            endDateTime: req.body.endDateTime
        });
        await event.save();

        let updatedEvent = await joinEvent(event.id, req.body.authorId, req.body.image);

        res.json(updatedEvent);
    }
    catch (e) {
        console.log(e.message);
        res.status(500).json({ error: e.message });
    }
});


eventRouter.get('/api/all-events', auth, async (req, res) => {
    try {
        const today = new Date();
        const events = await Events.find({ endDateTime: { $gt: today } }).sort({ endDateTime: 1 });
        console.log(events);
        res.json(events);
    }
    catch (e) {

        res.status(500).json({ error: e.message });
    }
});


eventRouter.get('/api/saved-events/:userId', auth, async (req, res) => {
    try {
        const userId = req.params.userId;
        const events = await Events.find({ savedMembers: { $in: [userId] } });
        console.log(events);
        res.json(events);
    }
    catch (e) {

        res.status(500).json({ error: e.message });
    }
});

eventRouter.get('/api/my-events/:userId', auth, async (req, res) => {
    try {
        const userId = req.params.userId;
        const events = await Events.find({}).where('authorId').equals(userId);
        console.log(events);
        res.json(events);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});

eventRouter.get('/api/past-events', auth, async (req, res) => {
    try {
        const today = new Date();
        const events = await Events.find({ endDateTime: { $lt: today } });
        res.json(events);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});

eventRouter.post('/api/save-event', auth, async (req, res) => {
    try {
        const { eventId, userId, add } = req.body;
        console.log(add);
        let event = await Events.findById(eventId);
        if (add == true) {
            event.savedMembers.push(userId);
        }
        else {
            const index = event.savedMembers.indexOf(userId);
            if (index > -1) {
                event.savedMembers.splice(index, 1);
            }
        }
        await event.save();
        return res.json();
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


async function joinEvent(eventId, userId, imageUrl) {
    try {
        let updatedEvent = await Events.findById(eventId);
        updatedEvent.memberIds.push(userId);
        updatedEvent.memberImageUrls.push(imageUrl);


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
        console.log(e.message);
        throw new Error(e.message);
    }
}

module.exports = eventRouter;