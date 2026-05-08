import { MapPin, Clock, DollarSign, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router';

export function SpotDetailsScreen() {
  const navigate = useNavigate();

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="bg-primary px-6 pt-12 pb-6">
        <button onClick={() => navigate(-1)} className="mb-4">
          <ArrowLeft className="w-6 h-6 text-white" />
        </button>
        <h1 className="text-white text-2xl font-bold">Spot Details</h1>
      </div>

      <div className="flex-1 overflow-y-auto px-6 py-6">
        <div className="bg-card border border-border rounded-2xl p-6 shadow-sm mb-4">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-3">
              <div className="w-16 h-16 bg-success/10 rounded-2xl flex items-center justify-center">
                <MapPin className="w-8 h-8 text-success" />
              </div>
              <div>
                <h2 className="text-2xl font-bold text-foreground">A-12</h2>
                <p className="text-sm text-muted-foreground">Zone A</p>
              </div>
            </div>
            <span className="px-4 py-2 bg-success/10 text-success font-medium rounded-full">
              Available
            </span>
          </div>

          <div className="space-y-4">
            <div className="flex items-start gap-3">
              <Clock className="w-5 h-5 text-primary mt-0.5" />
              <div className="flex-1">
                <h3 className="font-semibold text-foreground mb-1">Availability</h3>
                <p className="text-sm text-muted-foreground">Available now</p>
              </div>
            </div>

            <div className="h-px bg-border"></div>

            <div className="flex items-start gap-3">
              <DollarSign className="w-5 h-5 text-primary mt-0.5" />
              <div className="flex-1">
                <h3 className="font-semibold text-foreground mb-2">Pricing</h3>
                <div className="space-y-2">
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-muted-foreground">First hour</span>
                    <span className="font-semibold text-success">FREE</span>
                  </div>
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-muted-foreground">Additional hours</span>
                    <span className="font-semibold text-foreground">10 EGP/hour</span>
                  </div>
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-muted-foreground">Overstay penalty</span>
                    <span className="font-semibold text-destructive">20 EGP/hour</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-6">
          <h4 className="font-semibold text-blue-900 mb-2">Important Notice</h4>
          <ul className="space-y-1 text-sm text-blue-700">
            <li>• Please arrive within 15 minutes of booking</li>
            <li>• Parking in another user's spot will incur penalties</li>
            <li>• Overstaying will be charged at double rate</li>
          </ul>
        </div>

        <button
          onClick={() => navigate('/booking')}
          className="w-full bg-primary text-white py-4 rounded-xl font-medium shadow-md hover:bg-blue-700 transition-colors"
        >
          Book This Spot
        </button>
      </div>
    </div>
  );
}
