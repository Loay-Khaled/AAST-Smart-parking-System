import { Bell, CheckCircle, AlertCircle, Clock, XCircle, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router';

interface Notification {
  id: string;
  type: 'success' | 'warning' | 'error' | 'info';
  title: string;
  message: string;
  time: string;
  read: boolean;
}

export function NotificationsScreen() {
  const navigate = useNavigate();

  const notifications: Notification[] = [
    {
      id: '1',
      type: 'success',
      title: 'Booking Confirmed',
      message: 'Your parking spot A-12 has been reserved for 2 hours',
      time: '5 minutes ago',
      read: false,
    },
    {
      id: '2',
      type: 'warning',
      title: 'Parking Time Ending Soon',
      message: 'Your parking session will end in 15 minutes',
      time: '30 minutes ago',
      read: false,
    },
    {
      id: '3',
      type: 'info',
      title: 'Spot Available',
      message: 'A parking spot in Zone B is now available. Book now!',
      time: '2 hours ago',
      read: true,
    },
    {
      id: '4',
      type: 'error',
      title: 'Penalty Applied',
      message: 'Overstay penalty of 20 EGP has been applied to your account',
      time: 'Yesterday',
      read: true,
    },
    {
      id: '5',
      type: 'success',
      title: 'Booking Completed',
      message: 'Thank you for using AAST Parking. Total: 10 EGP',
      time: '2 days ago',
      read: true,
    },
  ];

  const getIcon = (type: string) => {
    switch (type) {
      case 'success':
        return <CheckCircle className="w-5 h-5 text-success" />;
      case 'warning':
        return <Clock className="w-5 h-5 text-warning" />;
      case 'error':
        return <XCircle className="w-5 h-5 text-destructive" />;
      case 'info':
        return <AlertCircle className="w-5 h-5 text-primary" />;
      default:
        return <Bell className="w-5 h-5 text-muted-foreground" />;
    }
  };

  const getBackgroundColor = (type: string) => {
    switch (type) {
      case 'success':
        return 'bg-success/10';
      case 'warning':
        return 'bg-warning/10';
      case 'error':
        return 'bg-destructive/10';
      case 'info':
        return 'bg-primary/10';
      default:
        return 'bg-muted';
    }
  };

  return (
    <div className="h-full w-full bg-background flex flex-col">
      <div className="bg-primary px-6 pt-12 pb-6">
        <button onClick={() => navigate(-1)} className="mb-4">
          <ArrowLeft className="w-6 h-6 text-white" />
        </button>
        <h1 className="text-white text-2xl font-bold">Notifications</h1>
      </div>

      <div className="flex-1 overflow-y-auto px-6 py-6">
        {notifications.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-12">
            <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center mb-4">
              <Bell className="w-10 h-10 text-muted-foreground" />
            </div>
            <p className="text-muted-foreground text-center">No notifications yet</p>
          </div>
        ) : (
          <div className="space-y-3">
            {notifications.map((notification) => (
              <div
                key={notification.id}
                className={`bg-card border ${
                  notification.read ? 'border-border' : 'border-primary/30 bg-primary/5'
                } rounded-xl p-4 shadow-sm`}
              >
                <div className="flex gap-3">
                  <div className={`w-10 h-10 ${getBackgroundColor(notification.type)} rounded-lg flex items-center justify-center flex-shrink-0`}>
                    {getIcon(notification.type)}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-2 mb-1">
                      <h3 className="font-semibold text-foreground">{notification.title}</h3>
                      {!notification.read && <div className="w-2 h-2 bg-primary rounded-full flex-shrink-0 mt-1.5"></div>}
                    </div>
                    <p className="text-sm text-muted-foreground mb-2">{notification.message}</p>
                    <p className="text-xs text-muted-foreground">{notification.time}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
