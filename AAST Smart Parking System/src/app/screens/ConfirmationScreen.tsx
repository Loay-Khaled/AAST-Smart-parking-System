import { Check, MapPin, Clock, DollarSign, QrCode } from 'lucide-react';
import { useNavigate } from 'react-router';

export function ConfirmationScreen() {
  const navigate = useNavigate();

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="flex-1 overflow-y-auto px-6 py-12">
        <div className="flex flex-col items-center mb-8">
          <div className="w-20 h-20 bg-success rounded-full flex items-center justify-center mb-4 shadow-lg">
            <Check className="w-10 h-10 text-white" strokeWidth={3} />
          </div>
          <h1 className="text-2xl font-bold text-foreground mb-2">Booking Confirmed!</h1>
          <p className="text-muted-foreground text-center">
            Your parking spot has been reserved successfully
          </p>
        </div>

        <div className="bg-card border border-border rounded-2xl p-6 shadow-sm mb-4">
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-primary/10 rounded-lg flex items-center justify-center">
                <MapPin className="w-5 h-5 text-primary" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Parking Spot</p>
                <p className="font-semibold text-foreground">Zone A - Spot 12</p>
              </div>
            </div>

            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-primary/10 rounded-lg flex items-center justify-center">
                <Clock className="w-5 h-5 text-primary" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Duration</p>
                <p className="font-semibold text-foreground">2 Hours (12:00 PM - 2:00 PM)</p>
              </div>
            </div>

            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-primary/10 rounded-lg flex items-center justify-center">
                <DollarSign className="w-5 h-5 text-primary" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Total Cost</p>
                <p className="font-semibold text-success">10 EGP</p>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-card border border-border rounded-2xl p-6 shadow-sm mb-6">
          <div className="flex items-center justify-center mb-3">
            <QrCode className="w-5 h-5 text-muted-foreground" />
            <h3 className="font-semibold text-foreground ml-2">Entry QR Code</h3>
          </div>
          <div className="bg-gradient-to-br from-primary/5 to-secondary/5 rounded-xl p-8 flex items-center justify-center">
            <div className="w-48 h-48 bg-white rounded-xl flex items-center justify-center border-4 border-primary/20">
              <div className="grid grid-cols-8 gap-1">
                {Array.from({ length: 64 }).map((_, i) => (
                  <div
                    key={i}
                    className={`w-2 h-2 ${Math.random() > 0.5 ? 'bg-foreground' : 'bg-white'} rounded-sm`}
                  ></div>
                ))}
              </div>
            </div>
          </div>
          <p className="text-xs text-muted-foreground text-center mt-3">
            Show this QR code at the parking entrance
          </p>
        </div>

        <button
          onClick={() => navigate('/home')}
          className="w-full bg-primary text-white py-4 rounded-xl font-medium shadow-md hover:bg-blue-700 transition-colors mb-3"
        >
          Back to Home
        </button>
        <button
          onClick={() => navigate('/bookings')}
          className="w-full bg-background border-2 border-primary text-primary py-4 rounded-xl font-medium hover:bg-primary/5 transition-colors"
        >
          View My Bookings
        </button>
      </div>
    </div>
  );
}
