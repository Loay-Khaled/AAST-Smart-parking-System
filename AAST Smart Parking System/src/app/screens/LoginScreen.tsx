import { Mail, Lock } from 'lucide-react';
import { useState } from 'react';
import { useNavigate } from 'react-router';
import logoImg from '../../imports/logo-1.png';

export function LoginScreen() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    navigate('/home');
  };

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="flex-1 flex flex-col items-center justify-center px-8 pb-20">
        <div className="w-24 h-24 bg-white rounded-full flex items-center justify-center shadow-lg mb-4 p-3 border-2 border-primary/20">
          <img src={logoImg} alt="AAST Logo" className="w-full h-full object-contain" />
        </div>

        <h1 className="text-3xl font-bold text-foreground mb-2">Welcome Back</h1>
        <p className="text-muted-foreground mb-8">Sign in to AAST Parking</p>

        <form onSubmit={handleLogin} className="w-full max-w-sm space-y-4">
          <div className="space-y-2">
            <label className="text-sm text-foreground">Email</label>
            <div className="relative">
              <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
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
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Enter your password"
                className="w-full pl-12 pr-4 py-3 bg-input-background border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary"
              />
            </div>
          </div>

          <button
            type="submit"
            className="w-full bg-primary text-white py-3.5 rounded-xl font-medium shadow-md hover:bg-blue-700 transition-colors mt-6"
          >
            Login
          </button>

          <button
            type="button"
            onClick={() => navigate('/register')}
            className="w-full text-primary py-2 text-sm font-medium"
          >
            Don't have an account? Create one
          </button>
        </form>
      </div>
    </div>
  );
}
