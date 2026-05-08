import { User, Car, CreditCard, Bell, Shield, LogOut, ChevronRight } from 'lucide-react';
import { BottomNav } from '../components/BottomNav';
import { useNavigate } from 'react-router';

export function ProfileScreen() {
  const navigate = useNavigate();

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="flex-1 overflow-y-auto pb-24">
        <div className="bg-primary px-6 pt-12 pb-8">
          <h1 className="text-white text-2xl font-bold mb-6">Profile</h1>
          <div className="flex items-center gap-4">
            <div className="w-20 h-20 bg-white/20 rounded-full flex items-center justify-center">
              <User className="w-10 h-10 text-white" />
            </div>
            <div>
              <h2 className="text-white text-xl font-bold">Omar Ahmed</h2>
              <p className="text-blue-100 text-sm">omar.ahmed@aast.edu</p>
            </div>
          </div>
        </div>

        <div className="px-6 py-6 space-y-6">
          <div className="bg-card border border-border rounded-2xl p-4 shadow-sm">
            <h3 className="font-semibold text-foreground mb-4">Vehicle Information</h3>
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 bg-primary/10 rounded-xl flex items-center justify-center">
                <Car className="w-6 h-6 text-primary" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Car Plate Number</p>
                <p className="font-semibold text-foreground">ABC 1234</p>
              </div>
            </div>
          </div>

          <div className="bg-card border border-border rounded-2xl p-4 shadow-sm">
            <h3 className="font-semibold text-foreground mb-4">Account Summary</h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Total Bookings</span>
                <span className="font-semibold text-foreground">12</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Active Penalties</span>
                <span className="font-semibold text-destructive">0 EGP</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Total Spent</span>
                <span className="font-semibold text-foreground">120 EGP</span>
              </div>
            </div>
          </div>

          <div className="bg-card border border-border rounded-2xl overflow-hidden shadow-sm">
            <button className="w-full flex items-center justify-between p-4 hover:bg-muted/50 transition-colors">
              <div className="flex items-center gap-3">
                <CreditCard className="w-5 h-5 text-muted-foreground" />
                <span className="text-foreground">Payment Methods</span>
              </div>
              <ChevronRight className="w-5 h-5 text-muted-foreground" />
            </button>
            <div className="h-px bg-border"></div>
            <button
              onClick={() => navigate('/notifications')}
              className="w-full flex items-center justify-between p-4 hover:bg-muted/50 transition-colors"
            >
              <div className="flex items-center gap-3">
                <Bell className="w-5 h-5 text-muted-foreground" />
                <span className="text-foreground">Notifications</span>
              </div>
              <ChevronRight className="w-5 h-5 text-muted-foreground" />
            </button>
            <div className="h-px bg-border"></div>
            <button className="w-full flex items-center justify-between p-4 hover:bg-muted/50 transition-colors">
              <div className="flex items-center gap-3">
                <Shield className="w-5 h-5 text-muted-foreground" />
                <span className="text-foreground">Privacy & Security</span>
              </div>
              <ChevronRight className="w-5 h-5 text-muted-foreground" />
            </button>
          </div>

          <button
            onClick={() => navigate('/login')}
            className="w-full flex items-center justify-center gap-2 bg-destructive/10 text-destructive py-4 rounded-xl font-medium hover:bg-destructive/20 transition-colors"
          >
            <LogOut className="w-5 h-5" />
            Logout
          </button>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
