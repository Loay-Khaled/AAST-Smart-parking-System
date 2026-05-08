const router = require('express').Router();
const auth = require('../middleware/auth');
const WaitingList = require('../models/WaitingList');

router.use(auth);

router.get('/my', async (req, res) => {
  try {
    const entry = await WaitingList.findOne({ userId: req.user.id, status: 'waiting' });
    const totalWaiting = await WaitingList.countDocuments({ status: 'waiting' });
    res.json({
      inQueue: !!entry,
      position: entry ? entry.position : null,
      totalWaiting,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.post('/join', async (req, res) => {
  try {
    const existing = await WaitingList.findOne({ userId: req.user.id, status: 'waiting' });
    if (existing) return res.status(409).json({ message: 'Already in queue' });

    const count = await WaitingList.countDocuments({ status: 'waiting' });
    const entry = await WaitingList.create({ userId: req.user.id, position: count + 1 });
    res.status(201).json(entry);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.delete('/leave', async (req, res) => {
  try {
    const entry = await WaitingList.findOneAndDelete({ userId: req.user.id, status: 'waiting' });
    if (!entry) return res.status(404).json({ message: 'Not in queue' });
    res.json({ message: 'Removed from waiting list' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
