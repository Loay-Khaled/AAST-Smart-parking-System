export function MobileContainer({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="w-full max-w-[390px] h-[844px] bg-card rounded-[40px] shadow-2xl overflow-hidden relative">
        {children}
      </div>
    </div>
  );
}
