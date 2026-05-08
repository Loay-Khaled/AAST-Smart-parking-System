import { Car } from 'lucide-react';
import logoImg from '../../imports/logo-1.png';

export function SplashScreen() {
  return (
    <div className="h-full w-full bg-gradient-to-br from-[#2563eb] to-[#06b6d4] flex flex-col items-center justify-center px-8">
      <div className="flex flex-col items-center gap-8">
        <div className="relative">
          <div className="w-40 h-40 bg-white rounded-full flex items-center justify-center shadow-2xl p-4">
            <img src={logoImg} alt="AAST Logo" className="w-full h-full object-contain" />
          </div>
          <div className="absolute -bottom-2 -right-2 w-16 h-16 bg-white rounded-2xl flex items-center justify-center shadow-xl">
            <Car className="w-9 h-9 text-[#2563eb]" strokeWidth={2.5} />
          </div>
        </div>
        <div className="text-center">
          <h1 className="text-white text-5xl font-bold tracking-tight mb-3">AAST Parking</h1>
          <p className="text-white text-xl mb-6">Smart Parking System</p>
          <div className="bg-white/20 backdrop-blur-sm px-6 py-2 rounded-full">
            <p className="text-white text-sm">Arab Academy for Science & Technology</p>
          </div>
        </div>
      </div>
    </div>
  );
}
