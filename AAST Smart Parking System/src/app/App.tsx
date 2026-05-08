import { BrowserRouter, Routes, Route, Navigate } from 'react-router';
import { MobileContainer } from './components/MobileContainer';
import { SplashScreen } from './screens/SplashScreen';
import { LoginScreen } from './screens/LoginScreen';
import { RegisterScreen } from './screens/RegisterScreen';
import { HomeScreen } from './screens/HomeScreen';
import { MapScreen } from './screens/MapScreen';
import { SpotDetailsScreen } from './screens/SpotDetailsScreen';
import { BookingScreen } from './screens/BookingScreen';
import { ConfirmationScreen } from './screens/ConfirmationScreen';
import { BookingsScreen } from './screens/BookingsScreen';
import { WaitingListScreen } from './screens/WaitingListScreen';
import { NotificationsScreen } from './screens/NotificationsScreen';
import { ProfileScreen } from './screens/ProfileScreen';
import { useState } from 'react';
import { LayoutGrid, Smartphone } from 'lucide-react';

export default function App() {
  const [viewMode, setViewMode] = useState<'app' | 'grid'>('grid');

  const ScreenWrapper = ({ children }: { children: React.ReactNode }) => (
    <BrowserRouter>
      {children}
    </BrowserRouter>
  );

  const screens = [
    { name: 'Splash Screen', component: <ScreenWrapper><SplashScreen /></ScreenWrapper> },
    { name: 'Login', component: <ScreenWrapper><LoginScreen /></ScreenWrapper> },
    { name: 'Register', component: <ScreenWrapper><RegisterScreen /></ScreenWrapper> },
    { name: 'Home', component: <ScreenWrapper><HomeScreen /></ScreenWrapper> },
    { name: 'Map', component: <ScreenWrapper><MapScreen /></ScreenWrapper> },
    { name: 'Spot Details', component: <ScreenWrapper><SpotDetailsScreen /></ScreenWrapper> },
    { name: 'Booking', component: <ScreenWrapper><BookingScreen /></ScreenWrapper> },
    { name: 'Confirmation', component: <ScreenWrapper><ConfirmationScreen /></ScreenWrapper> },
    { name: 'My Bookings', component: <ScreenWrapper><BookingsScreen /></ScreenWrapper> },
    { name: 'Waiting List', component: <ScreenWrapper><WaitingListScreen /></ScreenWrapper> },
    { name: 'Notifications', component: <ScreenWrapper><NotificationsScreen /></ScreenWrapper> },
    { name: 'Profile', component: <ScreenWrapper><ProfileScreen /></ScreenWrapper> },
  ];

  if (viewMode === 'grid') {
    return (
      <div className="min-h-screen bg-slate-900 p-8">
        <div className="max-w-[1800px] mx-auto">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h1 className="text-3xl font-bold text-white mb-2">AAST Smart Parking System</h1>
              <p className="text-slate-400">All Screens Preview</p>
            </div>
            <button
              onClick={() => setViewMode('app')}
              className="flex items-center gap-2 bg-primary text-white px-6 py-3 rounded-xl font-medium hover:bg-blue-700 transition-colors"
            >
              <Smartphone className="w-5 h-5" />
              Interactive Mode
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {screens.map((screen, index) => (
              <div key={index} className="bg-slate-800 rounded-2xl p-4 shadow-xl">
                <h3 className="text-white font-semibold mb-3 text-center">{screen.name}</h3>
                <div className="w-full aspect-[9/19.5] bg-card rounded-[32px] shadow-2xl overflow-hidden border-4 border-slate-700">
                  <div className="w-full h-full scale-100 origin-top-left">{screen.component}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background relative">
      <button
        onClick={() => setViewMode('grid')}
        className="absolute top-4 left-4 z-50 flex items-center gap-2 bg-slate-800 text-white px-4 py-2 rounded-lg font-medium hover:bg-slate-700 transition-colors shadow-lg"
      >
        <LayoutGrid className="w-4 h-4" />
        Grid View
      </button>
      <BrowserRouter>
        <MobileContainer>
          <Routes>
            <Route path="/" element={<Navigate to="/login" replace />} />
            <Route path="/splash" element={<SplashScreen />} />
            <Route path="/login" element={<LoginScreen />} />
            <Route path="/register" element={<RegisterScreen />} />
            <Route path="/home" element={<HomeScreen />} />
            <Route path="/map" element={<MapScreen />} />
            <Route path="/spot-details" element={<SpotDetailsScreen />} />
            <Route path="/booking" element={<BookingScreen />} />
            <Route path="/confirmation" element={<ConfirmationScreen />} />
            <Route path="/bookings" element={<BookingsScreen />} />
            <Route path="/waiting-list" element={<WaitingListScreen />} />
            <Route path="/notifications" element={<NotificationsScreen />} />
            <Route path="/profile" element={<ProfileScreen />} />
            <Route path="*" element={<Navigate to="/login" replace />} />
          </Routes>
        </MobileContainer>
      </BrowserRouter>
    </div>
  );
}