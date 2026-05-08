const mongoose = require('mongoose');

const parkingSpotSchema = new mongoose.Schema({
  spotId: { type: String, required: true, unique: true },
  zone: { type: String, enum: ['A', 'B', 'C'], required: true },
  status: { type: String, enum: ['available', 'occupied', 'reserved'], default: 'available' },
  floor: { type: Number, default: 1 },
  currentBookingId: { type: mongoose.Schema.Types.ObjectId, ref: 'Booking', default: null },
  availableAt: { type: Date, default: null },
});

module.exports = mongoose.model('ParkingSpot', parkingSpotSchema);
