const router = require('express').Router();
const adminAuth = require('../middleware/adminAuth');
const User = require('../models/User');
const Booking = require('../models/Booking');
const ParkingSpot = require('../models/ParkingSpot');
const Notification = require('../models/Notification');
const WaitingList = require('../models/WaitingList');

router.use(adminAuth);

// --- Stats ---
router.get('/stats', async (req, res) => {
  try {
    const [totalUsers, totalBookings, activeBookings, spots, waitingCount, revenueAgg] =
      await Promise.all([
        User.countDocuments({ role: 'user' }),
        Booking.countDocuments(),
        Booking.countDocuments({ status: 'active' }),
        ParkingSpot.find(),
        WaitingList.countDocuments({ status: 'waiting' }),
        Booking.aggregate([{ $group: { _id: null, total: { $sum: '$cost' } } }]),
      ]);

    const availableSpots = spots.filter((s) => s.status === 'available').length;
    const totalRevenue = revenueAgg[0]?.total || 0;

    res.json({
      totalUsers,
      totalBookings,
      activeBookings,
      availableSpots,
      totalSpots: spots.length,
      waitingCount,
      totalRevenue,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// --- Users ---
router.get('/users', async (req, res) => {
  try {
    const users = await User.find({ role: 'user' }).select('-password').sort({ createdAt: -1 });
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.patch('/users/:id', async (req, res) => {
  try {
    const { name, carPlate, activePenalties } = req.body;
    const updates = {};
    if (name !== undefined) updates.name = name;
    if (carPlate !== undefined) updates.carPlate = carPlate;
    if (activePenalties !== undefined) updates.activePenalties = Number(activePenalties);

    const user = await User.findByIdAndUpdate(req.params.id, updates, { new: true }).select('-password');
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.delete('/users/:id', async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) return res.status(404).json({ message: 'User not found' });
    await Promise.all([
      Booking.deleteMany({ userId: req.params.id }),
      Notification.deleteMany({ userId: req.params.id }),
      WaitingList.deleteMany({ userId: req.params.id }),
    ]);
    res.json({ message: 'User deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// --- Bookings ---
router.get('/bookings', async (req, res) => {
  try {
    const bookings = await Booking.find().sort({ createdAt: -1 });
    const userIds = [...new Set(bookings.map((b) => b.userId.toString()))];
    const users = await User.find({ _id: { $in: userIds } }).select('name email');
    const userMap = Object.fromEntries(users.map((u) => [u._id.toString(), u]));

    const result = bookings.map((b) => ({
      ...b.toObject(),
      user: userMap[b.userId.toString()] || null,
    }));
    res.json(result);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.patch('/bookings/:id/cancel', async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
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

// --- Spots ---
router.patch('/spots/:spotId', async (req, res) => {
  try {
    const { status } = req.body;
    if (!['available', 'occupied', 'reserved'].includes(status)) {
      return res.status(400).json({ message: 'Invalid status' });
    }
    const spot = await ParkingSpot.findOneAndUpdate(
      { spotId: req.params.spotId.toUpperCase() },
      { status, currentBookingId: null, availableAt: null },
      { new: true }
    );
    if (!spot) return res.status(404).json({ message: 'Spot not found' });
    res.json(spot);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// --- Notifications ---
router.get('/notifications', async (req, res) => {
  try {
    const notifications = await Notification.find().sort({ createdAt: -1 });
    const userIds = [...new Set(notifications.map((n) => n.userId.toString()))];
    const users = await User.find({ _id: { $in: userIds } }).select('email');
    const userMap = Object.fromEntries(users.map((u) => [u._id.toString(), u]));

    const result = notifications.map((n) => ({
      ...n.toObject(),
      userEmail: userMap[n.userId.toString()]?.email || '',
    }));
    res.json(result);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// --- Waiting List ---
router.get('/waitinglist', async (req, res) => {
  try {
    const entries = await WaitingList.find({ status: 'waiting' }).sort({ position: 1 });
    const userIds = entries.map((e) => e.userId);
    const users = await User.find({ _id: { $in: userIds } }).select('name email');
    const userMap = Object.fromEntries(users.map((u) => [u._id.toString(), u]));

    const result = entries.map((e) => ({
      ...e.toObject(),
      user: userMap[e.userId.toString()] || null,
    }));
    res.json(result);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.delete('/waitinglist/:id', async (req, res) => {
  try {
    const entry = await WaitingList.findByIdAndDelete(req.params.id);
    if (!entry) return res.status(404).json({ message: 'Entry not found' });
    res.json({ message: 'Removed from waiting list' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
