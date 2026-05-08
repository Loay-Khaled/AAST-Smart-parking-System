import { User, Mail, Lock, Car } from 'lucide-react';
import { useState } from 'react';
import { useNavigate } from 'react-router';
import logoImg from '../../imports/logo-1.png';

export function RegisterScreen() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    carPlate: '',
  });

  const handleRegister = (e: React.FormEvent) => {
    e.preventDefault();
    navigate('/home');
  };

  return (
    <div className="h-full w-full bg-background flex flex-col overflow-y-auto">
      <div className="flex-1 flex flex-col items-center justify-center px-8 py-12">
        <div className="w-20 h-20 bg-white rounded-full flex items-center justify-center shadow-lg mb-4 p-2 border-2 border-primary/20">
          <img src={logoImg} alt="AAST Logo" className="w-full h-full object-contain" />
        </div>
        <h1 className="text-3xl font-bold text-foreground mb-2">Create Account</h1>
        <p className="text-muted-foreground mb-6">Join AAST Parking today</p>

        <form onSubmit={handleRegister} className="w-full max-w-sm space-y-4">
          <div className="space-y-2">
            <label className="text-sm text-foreground">Full Name</label>
            <div className="relative">
              <User className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                placeholder="Omar Ahmed"
                className="w-full pl-12 pr-4 py-3 bg-input-background border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary"
              />
            </div>
          </div>

          <div className="space-y-2">
            <label className="text-sm text-foreground">Email</label>
            <div className="relative">
              <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <input
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                placeholder="your.email@aast.edu"
                className="w-full pl-12 pr-4 py-3 bg-input-background border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary"
              />
            </div>
          </div>

          <div className="space-y-2">
            <label className="text-sm text-foreground">Password</label>
            <div className="relative">
              <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <input
                type="password"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                placeholder="Create a strong password"
                className="w-full pl-12 pr-4 py-3 bg-input-background border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary"
              />
            </div>
          </div>

          <div className="space-y-2">
            <label className="text-sm text-foreground">Car Plate Number</label>
            <div className="relative">
              <Car className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <input
                type="text"
                value={formData.carPlate}
                onChange={(e) => setFormData({ ...formData, carPlate: e.target.value })}
                placeholder="ABC 1234"
                className="w-full pl-12 pr-4 py-3 bg-input-background border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary"
              />
            </div>
          </div>

          <button
            type="submit"
            className="w-full bg-primary text-white py-3.5 rounded-xl font-medium shadow-md hover:bg-blue-700 transition-colors mt-6"
          >
            Create Account
          </button>

          <button
            type="button"
            onClick={() => navigate('/login')}
            className="w-full text-primary py-2 text-sm font-medium"
          >
            Already have an account? Login
          </button>
        </form>
      </div>
    </div>
  );
}
