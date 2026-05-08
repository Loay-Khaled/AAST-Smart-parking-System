const router = require('express').Router();
const auth = require('../middleware/auth');
const Booking = require('../models/Booking');
const ParkingSpot = require('../models/ParkingSpot');
const User = require('../models/User');
const Notification = require('../models/Notification');

router.use(auth);

function calcCost(hours) {
  if (hours <= 1) return 0;
  return (hours - 1) * 10;
}

router.post('/', async (req, res) => {
  try {
    const { spotId, duration } = req.body;
    if (!spotId || !duration || duration < 1) {
      return res.status(400).json({ message: 'spotId and duration (>=1) are required' });
    }

    const spot = await ParkingSpot.findOne({ spotId: spotId.toUpperCase() });
    if (!spot) return res.status(404).json({ message: 'Spot not found' });
    if (spot.status !== 'available') {
      return res.status(409).json({ message: 'Spot is not available' });
    }

    const cost = calcCost(Number(duration));
    const startTime = new Date();
    const endTime = new Date(startTime.getTime() + Number(duration) * 60 * 60 * 1000);
    const qrCode = `AAST-${spotId.toUpperCase()}-${req.user.id}-${Date.now()}`;

    const booking = await Booking.create({
      userId: req.user.id,
      spotId: spotId.toUpperCase(),
      zone: spot.zone,
      duration: Number(duration),
      cost,
      startTime,
      endTime,
      qrCode,
    });

    spot.status = 'reserved';
    spot.currentBookingId = booking._id;
    spot.availableAt = endTime;
    await spot.save();

    await User.findByIdAndUpdate(req.user.id, {
      $inc: { totalBookings: 1, totalSpent: cost },
    });

    await Notification.create({
      userId: req.user.id,
      type: 'success',
      title: 'Booking Confirmed',
      message: `Spot ${spotId.toUpperCase()} reserved for ${duration} hour(s). ${cost === 0 ? 'First hour is FREE!' : `Total: ${cost} EGP`}`,
    });

    // Auto-complete after duration
    setTimeout(async () => {
      try {
        const b = await Booking.findById(booking._id);
        if (b && b.status === 'active') {
          b.status = 'completed';
          await b.save();
          await ParkingSpot.findOneAndUpdate(
            { spotId: b.spotId },
            { status: 'available', currentBookingId: null, availableAt: null }
          );
          await Notification.create({
            userId: b.userId,
            type: 'info',
            title: 'Booking Completed',
            message: `Your booking for spot ${b.spotId} has ended. Thank you!`,
          });
        }
      } catch (e) {
        console.error('Auto-complete error:', e.message);
      }
    }, Number(duration) * 60 * 60 * 1000);

    res.status(201).json(booking);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get('/my', async (req, res) => {
  try {
    const bookings = await Booking.find({ userId: req.user.id }).sort({ createdAt: -1 });
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) return res.status(404).json({ message: 'Booking not found' });
    res.json(booking);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.patch('/:id/cancel', async (req, res) => {
  try {
    const booking = await Booking.findOne({ _id: req.params.id, userId: req.user.id });
    if (!booking) return res.status(404).json({ message: 'Booking not found' });
    if (booking.status !== 'active') {
      return res.status(400).json({ message: 'Only active bookings can be cancelled' });
    }

    booking.status = 'cancelled';
    await booking.save();

    await ParkingSpot.findOneAndUpdate(
      { spotId: booking.spotId },
      { status: 'available', currentBookingId: null, availableAt: null }
    );

    res.json(booking);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
