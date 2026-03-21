'use client';

import { useState, useEffect } from 'react';
import { auth } from '@/lib/firebase';
import { onAuthStateChanged, User as FirebaseUser } from 'firebase/auth';
import Image from 'next/image';
import MediaRow from '@/components/MediaRow';
import ContentModal from '@/components/ContentModal';
import { LogOut, Heart, Clock, Settings, Shield } from 'lucide-react';
import { signOut } from 'firebase/auth';
import { useRouter } from 'next/navigation';

export default function ProfilePage() {
  const [user, setUser] = useState<FirebaseUser | null>(null);
  const [watchlist, setWatchlist] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedContent, setSelectedContent] = useState<{id: number, type: string} | null>(null);
  const router = useRouter();

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (currentUser) => {
      setUser(currentUser);
      if (currentUser) {
        await fetchWatchlist(currentUser);
      } else {
        setLoading(false);
      }
    });
    return () => unsubscribe();
  }, []);

  const fetchWatchlist = async (currentUser: FirebaseUser) => {
    try {
      const token = await currentUser.getIdToken();
      const res = await fetch('/api/watchlist', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      const data = await res.json();
      if (Array.isArray(data)) {
        // Map backend schema to UI component expectations
        const mappedData = data.map(item => ({
          id: item.mediaId,
          poster_path: item.posterPath,
          title: item.title,
          media_type: item.type
        }));
        setWatchlist(mappedData);
      }
    } catch (error) {
      console.error('Failed to fetch watchlist:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    await signOut(auth);
    router.push('/');
  };

  const handleCardClick = (id: number, type: string) => {
    setSelectedContent({ id, type });
  };

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  if (!user) return (
    <div className="min-h-screen flex flex-col items-center justify-center gap-6 p-4 text-center">
      <div className="w-20 h-20 bg-white/5 rounded-full flex items-center justify-center border border-white/10">
        <Shield className="w-10 h-10 text-blue-500" />
      </div>
      <div className="space-y-2">
        <h1 className="text-2xl font-bold">Authentication Required</h1>
        <p className="text-white/50 max-w-xs">Please sign in to view your profile and managed your watchlist.</p>
      </div>
      <button 
        onClick={() => router.push('/')}
        className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-full transition-all active:scale-95"
      >
        Go to Home
      </button>
    </div>
  );

  return (
    <div className="min-h-screen bg-[#0a0a0a] pb-20">
      {/* Profile Header */}
      <div className="relative h-[40vh] w-full bg-linear-to-b from-blue-900/20 to-[#0a0a0a] flex items-end px-4 md:px-16 pb-8 md:pb-12 border-b border-white/5">
        <div className="flex flex-col md:flex-row items-center md:items-end gap-6 md:gap-8 w-full">
          <div className="relative w-32 h-32 md:w-40 md:h-40 rounded-full overflow-hidden border-4 border-[#0a0a0a] shadow-2xl">
            <Image
              src={user.photoURL || '/assets/images/google_logo.png'}
              alt={user.displayName || 'User'}
              fill
              className="object-cover"
            />
          </div>
          <div className="flex-1 text-center md:text-left space-y-2">
            <h1 className="text-3xl md:text-5xl font-black text-white tracking-tight">
              {user.displayName}
            </h1>
            <p className="text-white/50 font-medium">{user.email}</p>
            <div className="flex flex-wrap justify-center md:justify-start gap-4 mt-4">
              <div className="bg-white/5 border border-white/10 px-4 py-2 rounded-full flex items-center gap-2">
                <Heart className="w-4 h-4 text-pink-500" />
                <span className="text-sm font-bold">{watchlist.length} Saved</span>
              </div>
              <div className="bg-white/5 border border-white/10 px-4 py-2 rounded-full flex items-center gap-2">
                <Clock className="w-4 h-4 text-orange-500" />
                <span className="text-sm font-bold">Activity Log</span>
              </div>
            </div>
          </div>
          <div className="flex gap-3">
            <button className="p-3 bg-white/5 hover:bg-white/10 text-white rounded-full border border-white/10 transition-colors">
              <Settings className="w-6 h-6" />
            </button>
            <button 
              onClick={handleLogout}
              className="px-6 py-3 bg-red-600/10 hover:bg-red-600 text-red-500 hover:text-white font-bold rounded-xl border border-red-600/20 transition-all flex items-center gap-2"
            >
              <LogOut className="w-5 h-5" />
              <span>Sign Out</span>
            </button>
          </div>
        </div>
      </div>

      {/* Profile Content */}
      <div className="py-8 space-y-12">
        {watchlist.length > 0 ? (
          <MediaRow 
            title="Your Watchlist" 
            data={watchlist} 
            mediaType="watchlist" 
            onCardClick={handleCardClick}
          />
        ) : (
          <div className="flex flex-col items-center justify-center py-20 px-4 text-center gap-4">
            <div className="w-16 h-16 bg-white/5 rounded-2xl flex items-center justify-center border border-white/10 opacity-50">
              <Heart className="w-8 h-8" />
            </div>
            <div className="space-y-1">
              <h3 className="text-xl font-bold text-white/80">Your watchlist is empty</h3>
              <p className="text-white/40 max-w-xs">Start adding movies and shows you want to watch later!</p>
            </div>
            <button 
              onClick={() => router.push('/')}
              className="text-blue-500 font-bold hover:underline mt-2"
            >
              Browse trending content
            </button>
          </div>
        )}
      </div>

      {/* Content Modal */}
      {selectedContent && (
        <ContentModal
          contentId={selectedContent.id}
          mediaType={selectedContent.type}
          onClose={() => setSelectedContent(null)}
        />
      )}
    </div>
  );
}
