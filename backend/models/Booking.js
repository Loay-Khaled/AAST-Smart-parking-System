const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  spotId: { type: String, required: true },
  zone: { type: String, required: true },
  duration: { type: Number, required: true },
  cost: { type: Number, required: true },
  startTime: { type: Date, required: true },
  endTime: { type: Date, required: true },
  status: { type: String, enum: ['active', 'completed', 'cancelled'], default: 'active' },
  qrCode: { type: String, required: true },
  penalty: { type: Number, default: 0 },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Booking', bookingSchema);
