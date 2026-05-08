const router = require('express').Router();
const auth = require('../middleware/auth');
const ParkingSpot = require('../models/ParkingSpot');

router.use(auth);

router.get('/', async (req, res) => {
  try {
    const spots = await ParkingSpot.find().sort({ spotId: 1 });
    const availableCount = spots.filter((s) => s.status === 'available').length;
    res.json({ spots, availableCount, totalCount: spots.length });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get('/zone/:zone', async (req, res) => {
  try {
    const spots = await ParkingSpot.find({ zone: req.params.zone.toUpperCase() }).sort({ spotId: 1 });
    res.json(spots);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get('/:spotId', async (req, res) => {
  try {
    const spot = await ParkingSpot.findOne({ spotId: req.params.spotId.toUpperCase() });
    if (!spot) return res.status(404).json({ message: 'Spot not found' });
    res.json(spot);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
