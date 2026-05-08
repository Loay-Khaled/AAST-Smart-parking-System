import { MapPin, Clock, Calendar, ChevronRight } from 'lucide-react';
import { BottomNav } from '../components/BottomNav';

interface Booking {
  id: string;
  spot: string;
  zone: string;
  date: string;
  time: string;
  duration: string;
  cost: number;
  status: 'active' | 'completed' | 'cancelled';
}

export function BookingsScreen() {
  const activeBookings: Booking[] = [
    {
      id: '1',
      spot: 'A-12',
      zone: 'Zone A',
      date: 'Today',
      time: '12:00 PM - 2:00 PM',
      duration: '2 hours',
      cost: 10,
      status: 'active',
    },
  ];

  const pastBookings: Booking[] = [
    {
      id: '2',
      spot: 'B-05',
      zone: 'Zone B',
      date: 'Apr 24, 2026',
      time: '9:00 AM - 11:00 AM',
      duration: '2 hours',
      cost: 10,
      status: 'completed',
    },
    {
      id: '3',
      spot: 'C-18',
      zone: 'Zone C',
      date: 'Apr 20, 2026',
      time: '2:00 PM - 5:00 PM',
      duration: '3 hours',
      cost: 20,
      status: 'completed',
    },
    {
      id: '4',
      spot: 'A-03',
      zone: 'Zone A',
      date: 'Apr 15, 2026',
      time: '10:00 AM - 11:00 AM',
      duration: '1 hour',
      cost: 0,
      status: 'completed',
    },
  ];

  const BookingCard = ({ booking }: { booking: Booking }) => (
    <div
      className={`bg-card border ${
        booking.status === 'active' ? 'border-primary bg-primary/5' : 'border-border'
      } rounded-2xl p-4 shadow-sm`}
    >
      <div className="flex items-start justify-between mb-3">
        <div className="flex items-center gap-3">
          <div
            className={`w-12 h-12 ${
              booking.status === 'active' ? 'bg-primary/10' : 'bg-muted'
            } rounded-xl flex items-center justify-center`}
          >
            <MapPin className={`w-6 h-6 ${booking.status === 'active' ? 'text-primary' : 'text-muted-foreground'}`} />
          </div>
          <div>
            <h3 className="font-semibold text-foreground">{booking.spot}</h3>
            <p className="text-sm text-muted-foreground">{booking.zone}</p>
          </div>
        </div>
        {booking.status === 'active' && (
          <span className="px-3 py-1 bg-success/10 text-success text-xs font-medium rounded-full">Active</span>
        )}
      </div>

      <div className="space-y-2">
        <div className="flex items-center gap-2 text-sm text-muted-foreground">
          <Calendar className="w-4 h-4" />
          <span>{booking.date}</span>
        </div>
        <div className="flex items-center gap-2 text-sm text-muted-foreground">
          <Clock className="w-4 h-4" />
          <span>{booking.time}</span>
        </div>
        <div className="flex items-center justify-between pt-2 border-t border-border">
          <span className="text-sm text-muted-foreground">Total</span>
          <span className="font-semibold text-foreground">
            {booking.cost === 0 ? 'FREE' : `${booking.cost} EGP`}
          </span>
        </div>
      </div>

      {booking.status === 'active' && (
        <button className="w-full mt-4 bg-background border border-border text-foreground py-2.5 rounded-xl text-sm font-medium hover:bg-muted/50 transition-colors">
          View Details
        </button>
      )}
    </div>
  );

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="flex-1 overflow-y-auto pb-24">
        <div className="bg-primary px-6 pt-12 pb-6">
          <h1 className="text-white text-2xl font-bold">My Bookings</h1>
        </div>

        <div className="px-6 py-6 space-y-6">
          {activeBookings.length > 0 && (
            <div>
              <h2 className="font-semibold text-foreground mb-3">Active Bookings</h2>
              <div className="space-y-3">
                {activeBookings.map((booking) => (
                  <BookingCard key={booking.id} booking={booking} />
                ))}
              </div>
            </div>
          )}

          <div>
            <h2 className="font-semibold text-foreground mb-3">Past Bookings</h2>
            <div className="space-y-3">
              {pastBookings.map((booking) => (
                <BookingCard key={booking.id} booking={booking} />
              ))}
            </div>
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
