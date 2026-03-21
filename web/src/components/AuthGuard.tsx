'use client';

import { useState, useEffect, Suspense } from 'react';
import { onAuthStateChanged, User } from 'firebase/auth';
import { auth } from '@/lib/firebase';
import WelcomeScreen from '@/components/WelcomeScreen';
import { usePathname, useSearchParams } from 'next/navigation';

function AuthContent({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const token = searchParams.get('token');

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
      setLoading(false);
    });
    return () => unsubscribe();
  }, []);

  // Skip auth check for player routes or if an external token is provided
  const isPlayerRoute = pathname.startsWith('/movie/') || pathname.startsWith('/tv/');
  if (isPlayerRoute || token) {
    return <>{children}</>;
  }

  if (loading) {
    return (
      <div className="h-screen bg-black flex items-center justify-center">
        <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!user) {
    return <WelcomeScreen />;
  }

  return <>{children}</>;
}

export default function AuthGuard({ children }: { children: React.ReactNode }) {
  return (
    <Suspense fallback={
      <div className="h-screen bg-black flex items-center justify-center">
        <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
      </div>
    }>
      <AuthContent>{children}</AuthContent>
    </Suspense>
  );
}
