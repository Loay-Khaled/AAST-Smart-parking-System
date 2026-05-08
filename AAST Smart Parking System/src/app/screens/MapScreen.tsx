import { MapPin, Search } from 'lucide-react';
import { BottomNav } from '../components/BottomNav';
import { useNavigate } from 'react-router';

type SpotStatus = 'available' | 'occupied' | 'reserved';

interface ParkingSpot {
  id: string;
  zone: string;
  status: SpotStatus;
  availableAt?: string;
}

export function MapScreen() {
  const navigate = useNavigate();

  const spots: ParkingSpot[] = [
    { id: 'A1', zone: 'A', status: 'available' },
    { id: 'A2', zone: 'A', status: 'available' },
    { id: 'A3', zone: 'A', status: 'occupied' },
    { id: 'A4', zone: 'A', status: 'available' },
    { id: 'A5', zone: 'A', status: 'reserved', availableAt: '2:00 PM' },
    { id: 'A6', zone: 'A', status: 'available' },
    { id: 'B1', zone: 'B', status: 'occupied' },
    { id: 'B2', zone: 'B', status: 'available' },
    { id: 'B3', zone: 'B', status: 'available' },
    { id: 'B4', zone: 'B', status: 'occupied' },
    { id: 'B5', zone: 'B', status: 'available' },
    { id: 'B6', zone: 'B', status: 'reserved', availableAt: '3:30 PM' },
    { id: 'C1', zone: 'C', status: 'available' },
    { id: 'C2', zone: 'C', status: 'occupied' },
    { id: 'C3', zone: 'C', status: 'available' },
    { id: 'C4', zone: 'C', status: 'available' },
    { id: 'C5', zone: 'C', status: 'occupied' },
    { id: 'C6', zone: 'C', status: 'available' },
  ];

  const getSpotColor = (status: SpotStatus) => {
    switch (status) {
      case 'available':
        return 'bg-success border-success/30';
      case 'occupied':
        return 'bg-occupied border-occupied/30';
      case 'reserved':
        return 'bg-reserved border-reserved/30';
    }
  };

  const getSpotTextColor = (status: SpotStatus) => {
    return 'text-white';
  };

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="flex-1 overflow-y-auto pb-24">
        <div className="bg-primary px-6 pt-12 pb-6">
          <h1 className="text-white text-2xl font-bold mb-4">Parking Map</h1>
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
            <input
              type="text"
              placeholder="Search spot or zone..."
              className="w-full pl-12 pr-4 py-3 bg-white border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-white"
            />
          </div>
        </div>

        <div className="px-6 py-6">
          <div className="flex items-center gap-4 mb-6">
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 bg-success rounded"></div>
              <span className="text-xs text-muted-foreground">Available</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 bg-occupied rounded"></div>
              <span className="text-xs text-muted-foreground">Occupied</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 bg-reserved rounded"></div>
              <span className="text-xs text-muted-foreground">Reserved</span>
            </div>
          </div>

          {['A', 'B', 'C'].map((zone) => (
            <div key={zone} className="mb-6">
              <div className="flex items-center gap-2 mb-3">
                <MapPin className="w-4 h-4 text-primary" />
                <h3 className="font-semibold text-foreground">Zone {zone}</h3>
              </div>
              <div className="grid grid-cols-3 gap-3">
                {spots
                  .filter((spot) => spot.zone === zone)
                  .map((spot) => (
                    <button
                      key={spot.id}
                      onClick={() => spot.status !== 'occupied' && navigate('/spot-details')}
                      disabled={spot.status === 'occupied'}
                      className={`${getSpotColor(spot.status)} ${getSpotTextColor(spot.status)} border-2 rounded-xl p-4 text-center transition-all ${
                        spot.status !== 'occupied' ? 'hover:scale-105 active:scale-95' : 'opacity-60 cursor-not-allowed'
                      }`}
                    >
                      <div className="font-bold text-lg">{spot.id}</div>
                      {spot.availableAt && (
                        <div className="text-xs mt-1 opacity-90">{spot.availableAt}</div>
                      )}
                    </button>
                  ))}
              </div>
            </div>
          ))}
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
