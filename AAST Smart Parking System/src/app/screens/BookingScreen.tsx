import { Clock, DollarSign, ArrowLeft, Calendar } from 'lucide-react';
import { useState } from 'react';
import { useNavigate } from 'react-router';

export function BookingScreen() {
  const navigate = useNavigate();
  const [duration, setDuration] = useState(2);

  const calculatePrice = (hours: number) => {
    if (hours <= 1) return 0;
    return (hours - 1) * 10;
  };

  const price = calculatePrice(duration);

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="bg-primary px-6 pt-12 pb-6">
        <button onClick={() => navigate(-1)} className="mb-4">
          <ArrowLeft className="w-6 h-6 text-white" />
        </button>
        <h1 className="text-white text-2xl font-bold">Book Spot A-12</h1>
      </div>

      <div className="flex-1 overflow-y-auto px-6 py-6">
        <div className="bg-card border border-border rounded-2xl p-6 shadow-sm mb-4">
          <h3 className="font-semibold text-foreground mb-4 flex items-center gap-2">
            <Clock className="w-5 h-5 text-primary" />
            Select Duration
          </h3>

          <div className="space-y-3 mb-6">
            {[1, 2, 3, 4, 5].map((hours) => (
              <button
                key={hours}
                onClick={() => setDuration(hours)}
                className={`w-full flex items-center justify-between p-4 rounded-xl border-2 transition-all ${
                  duration === hours
                    ? 'border-primary bg-primary/5'
                    : 'border-border bg-background hover:border-primary/30'
                }`}
              >
                <div className="flex items-center gap-3">
                  <div
                    className={`w-5 h-5 rounded-full border-2 flex items-center justify-center ${
                      duration === hours ? 'border-primary' : 'border-border'
                    }`}
                  >
                    {duration === hours && <div className="w-2.5 h-2.5 bg-primary rounded-full"></div>}
                  </div>
                  <span className="font-medium text-foreground">
                    {hours} {hours === 1 ? 'Hour' : 'Hours'}
                  </span>
                </div>
                <span className="font-semibold text-foreground">
                  {calculatePrice(hours) === 0 ? 'FREE' : `${calculatePrice(hours)} EGP`}
                </span>
              </button>
            ))}
          </div>
        </div>

        <div className="bg-card border border-border rounded-2xl p-6 shadow-sm mb-6">
          <h3 className="font-semibold text-foreground mb-4 flex items-center gap-2">
            <DollarSign className="w-5 h-5 text-primary" />
            Price Breakdown
          </h3>

          <div className="space-y-3">
            <div className="flex items-center justify-between text-sm">
              <span className="text-muted-foreground">First hour</span>
              <span className="font-medium text-success">FREE</span>
            </div>
            {duration > 1 && (
              <div className="flex items-center justify-between text-sm">
                <span className="text-muted-foreground">
                  {duration - 1} additional {duration - 1 === 1 ? 'hour' : 'hours'} × 10 EGP
                </span>
                <span className="font-medium text-foreground">{(duration - 1) * 10} EGP</span>
              </div>
            )}
            <div className="h-px bg-border"></div>
            <div className="flex items-center justify-between">
              <span className="font-semibold text-foreground">Total Cost</span>
              <span className="text-2xl font-bold text-primary">
                {price === 0 ? 'FREE' : `${price} EGP`}
              </span>
            </div>
          </div>
        </div>

        <div className="bg-card border border-border rounded-2xl p-4 shadow-sm mb-6">
          <div className="flex items-center gap-3 text-sm text-muted-foreground">
            <Calendar className="w-4 h-4" />
            <span>
              Start: <span className="font-medium text-foreground">Now</span>
            </span>
            <span>•</span>
            <span>
              End:{' '}
              <span className="font-medium text-foreground">
                {new Date(Date.now() + duration * 60 * 60 * 1000).toLocaleTimeString('en-US', {
                  hour: 'numeric',
                  minute: '2-digit',
                })}
              </span>
            </span>
          </div>
        </div>

        <button
          onClick={() => navigate('/confirmation')}
          className="w-full bg-primary text-white py-4 rounded-xl font-medium shadow-md hover:bg-blue-700 transition-colors"
        >
          Confirm Booking
        </button>
      </div>
    </div>
  );
}
