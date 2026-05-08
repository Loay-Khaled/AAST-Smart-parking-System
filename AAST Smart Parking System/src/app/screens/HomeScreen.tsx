import { MapPin, Clock, Car, Bell } from 'lucide-react';
import { BottomNav } from '../components/BottomNav';
import { useNavigate } from 'react-router';
import logoImg from '../../imports/logo-1.png';

export function HomeScreen() {
  const navigate = useNavigate();

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="flex-1 overflow-y-auto pb-24">
        <div className="bg-gradient-to-br from-primary to-blue-600 px-6 pt-12 pb-8 rounded-b-3xl">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-white rounded-full flex items-center justify-center p-1.5">
                <img src={logoImg} alt="AAST" className="w-full h-full object-contain" />
              </div>
              <div>
                <p className="text-blue-100 text-sm">Welcome back,</p>
                <h2 className="text-white text-xl font-bold">Omar Ahmed</h2>
              </div>
            </div>
            <button className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center">
              <Bell className="w-5 h-5 text-white" />
            </button>
          </div>

          <div className="bg-white rounded-2xl p-4 shadow-lg">
            <div className="flex items-center justify-between mb-3">
              <span className="text-sm text-muted-foreground">Available Spots</span>
              <span className="text-2xl font-bold text-success">24</span>
            </div>
            <div className="h-2 bg-muted rounded-full overflow-hidden">
              <div className="h-full bg-success rounded-full" style={{ width: '48%' }}></div>
            </div>
            <p className="text-xs text-muted-foreground mt-2">24 of 50 spots available</p>
          </div>
        </div>

        <div className="px-6 py-6 space-y-4">
          <div className="bg-card border border-border rounded-2xl p-4 shadow-sm">
            <div className="flex items-start justify-between mb-3">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 bg-success/10 rounded-xl flex items-center justify-center">
                  <MapPin className="w-6 h-6 text-success" />
                </div>
                <div>
                  <h3 className="font-semibold text-foreground">Nearest Spot</h3>
                  <p className="text-sm text-muted-foreground">Zone A - Spot 12</p>
                </div>
              </div>
              <span className="px-3 py-1 bg-success/10 text-success text-xs font-medium rounded-full">
                Available
              </span>
            </div>
            <button
              onClick={() => navigate('/spot-details')}
              className="w-full bg-primary text-white py-3 rounded-xl font-medium shadow-sm hover:bg-blue-700 transition-colors"
            >
              Book Now
            </button>
          </div>

          <div className="bg-card border border-border rounded-2xl p-4 shadow-sm">
            <h3 className="font-semibold text-foreground mb-3 flex items-center gap-2">
              <Clock className="w-5 h-5 text-primary" />
              Quick Summary
            </h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Total Bookings</span>
                <span className="font-semibold text-foreground">12</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Active Booking</span>
                <span className="font-semibold text-warning">1</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Penalties</span>
                <span className="font-semibold text-destructive">0 EGP</span>
              </div>
            </div>
          </div>

          <div className="bg-gradient-to-r from-secondary/10 to-primary/10 border border-secondary/20 rounded-2xl p-4">
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 bg-white rounded-full flex items-center justify-center flex-shrink-0">
                <Car className="w-5 h-5 text-secondary" />
              </div>
              <div>
                <h4 className="font-semibold text-foreground mb-1">First Hour Free!</h4>
                <p className="text-sm text-muted-foreground">
                  Book any spot and enjoy your first hour completely free. Additional hours only 10 EGP.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
