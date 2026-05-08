const router = require('express').Router();
const auth = require('../middleware/auth');
const User = require('../models/User');

router.use(auth);

router.get('/', async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.patch('/', async (req, res) => {
  try {
    const { name, carPlate } = req.body;
    const updates = {};
    if (name) updates.name = name;
    if (carPlate !== undefined) updates.carPlate = carPlate;

    const user = await User.findByIdAndUpdate(req.user.id, updates, { new: true }).select('-password');
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
