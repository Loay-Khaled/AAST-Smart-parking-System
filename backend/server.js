require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/spots', require('./routes/spots'));
app.use('/api/bookings', require('./routes/bookings'));
app.use('/api/notifications', require('./routes/notifications'));
app.use('/api/waitinglist', require('./routes/waitinglist'));
app.use('/api/profile', require('./routes/profile'));
app.use('/api/admin', require('./routes/admin'));

async function seedAdmin() {
  const User = require('./models/User');
  const existing = await User.findOne({ role: 'admin' });
  if (existing) {
    console.log('Admin user already exists');
    return;
  }
  await User.create({
    name: 'Admin',
    email: 'admin@aast.edu',
    password: 'Admin123456@',
    role: 'admin',
  });
  console.log('Admin user seeded: admin@aast.edu / Admin123456@');
}

async function seedSpots() {
  const ParkingSpot = require('./models/ParkingSpot');
  const count = await ParkingSpot.countDocuments();
  if (count > 0) return;

  const spots = [];
  const zones = ['A', 'B', 'C'];
  const statuses = ['available', 'available', 'available', 'available', 'occupied', 'reserved'];

  for (const zone of zones) {
    for (let i = 1; i <= 6; i++) {
      const spotId = `${zone}${i}`;
      const status = statuses[Math.floor(Math.random() * statuses.length)];
      spots.push({ spotId, zone, status, floor: zone === 'A' ? 1 : zone === 'B' ? 2 : 3 });
    }
  }

  await ParkingSpot.insertMany(spots);
  console.log('Seeded 18 parking spots');
}

mongoose
  .connect(process.env.MONGODB_URI)
  .then(async () => {
    console.log('Connected to MongoDB Atlas');
    await seedSpots();
    await seedAdmin();
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
  })
  .catch((err) => {
    console.error('MongoDB connection error:', err);
    process.exit(1);
  });
