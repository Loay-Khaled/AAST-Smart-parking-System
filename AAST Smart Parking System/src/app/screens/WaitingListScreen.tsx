import { Users, Clock, ArrowLeft } from 'lucide-react';
import { useState } from 'react';
import { useNavigate } from 'react-router';

export function WaitingListScreen() {
  const navigate = useNavigate();
  const [isInQueue, setIsInQueue] = useState(false);
  const [queuePosition, setQueuePosition] = useState(5);

  const handleJoinQueue = () => {
    setIsInQueue(true);
  };

  const handleLeaveQueue = () => {
    setIsInQueue(false);
  };

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="bg-primary px-6 pt-12 pb-6">
        <button onClick={() => navigate(-1)} className="mb-4">
          <ArrowLeft className="w-6 h-6 text-white" />
        </button>
        <h1 className="text-white text-2xl font-bold">Waiting List</h1>
      </div>

      <div className="flex-1 overflow-y-auto px-6 py-6">
        {!isInQueue ? (
          <>
            <div className="flex flex-col items-center justify-center py-12">
              <div className="w-24 h-24 bg-warning/10 rounded-full flex items-center justify-center mb-6">
                <Users className="w-12 h-12 text-warning" />
              </div>
              <h2 className="text-xl font-bold text-foreground mb-2">Parking Full</h2>
              <p className="text-muted-foreground text-center mb-8">
                All parking spots are currently occupied. Join the waiting list to be notified when a spot becomes
                available.
              </p>
            </div>

            <div className="bg-card border border-border rounded-2xl p-6 shadow-sm mb-6">
              <h3 className="font-semibold text-foreground mb-4">How It Works</h3>
              <div className="space-y-3">
                <div className="flex gap-3">
                  <div className="w-6 h-6 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5">
                    <span className="text-xs font-bold text-primary">1</span>
                  </div>
                  <div>
                    <p className="text-sm text-foreground">Join the waiting list</p>
                    <p className="text-xs text-muted-foreground">Get in line for the next available spot</p>
                  </div>
                </div>
                <div className="flex gap-3">
                  <div className="w-6 h-6 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5">
                    <span className="text-xs font-bold text-primary">2</span>
                  </div>
                  <div>
                    <p className="text-sm text-foreground">Receive notification</p>
                    <p className="text-xs text-muted-foreground">We'll alert you when a spot opens up</p>
                  </div>
                </div>
                <div className="flex gap-3">
                  <div className="w-6 h-6 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5">
                    <span className="text-xs font-bold text-primary">3</span>
                  </div>
                  <div>
                    <p className="text-sm text-foreground">Confirm within time limit</p>
                    <p className="text-xs text-muted-foreground">You'll have 5 minutes to book the spot</p>
                  </div>
                </div>
              </div>
            </div>

            <button
              onClick={handleJoinQueue}
              className="w-full bg-primary text-white py-4 rounded-xl font-medium shadow-md hover:bg-blue-700 transition-colors"
            >
              Join Waiting List
            </button>
          </>
        ) : (
          <>
            <div className="bg-gradient-to-br from-primary/10 to-secondary/10 border border-primary/20 rounded-2xl p-6 mb-6">
              <div className="flex flex-col items-center text-center mb-4">
                <div className="w-16 h-16 bg-primary rounded-full flex items-center justify-center mb-4">
                  <Users className="w-8 h-8 text-white" />
                </div>
                <h2 className="text-xl font-bold text-foreground mb-2">You're in the Queue!</h2>
                <p className="text-muted-foreground mb-4">We'll notify you when a spot becomes available</p>
              </div>

              <div className="bg-white rounded-xl p-6 text-center">
                <p className="text-sm text-muted-foreground mb-2">Your position</p>
                <div className="text-5xl font-bold text-primary mb-2">{queuePosition}</div>
                <p className="text-xs text-muted-foreground">people ahead of you</p>
              </div>
            </div>

            <div className="bg-card border border-border rounded-2xl p-4 shadow-sm mb-6">
              <div className="flex items-start gap-3">
                <Clock className="w-5 h-5 text-warning mt-0.5" />
                <div>
                  <h3 className="font-semibold text-foreground mb-1">Estimated Wait Time</h3>
                  <p className="text-sm text-muted-foreground">Approximately 15-20 minutes based on current queue</p>
                </div>
              </div>
            </div>

            <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4 mb-6">
              <p className="text-sm text-yellow-800">
                You'll receive a notification when a spot becomes available. Make sure to confirm within 5 minutes or
                you'll lose your spot.
              </p>
            </div>

            <button
              onClick={handleLeaveQueue}
              className="w-full bg-background border-2 border-destructive text-destructive py-4 rounded-xl font-medium hover:bg-destructive/5 transition-colors"
            >
              Leave Queue
            </button>
          </>
        )}
      </div>
    </div>
  );
}
