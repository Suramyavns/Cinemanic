'use client';

import Link from 'next/link';
import Image from 'next/image';
import { useState, useEffect, useRef } from 'react';
import { Search, User, X, Film, Tv, LogOut, Heart, Clock } from 'lucide-react';
import { searchContent } from '@/services/tmdb';
import { imageUrlBuilder } from '@/lib/images';
import { motion, AnimatePresence } from 'framer-motion';
import { auth, googleProvider } from '@/lib/firebase';
import { signInWithPopup, signOut, onAuthStateChanged, User as FirebaseUser } from 'firebase/auth';

export default function Navbar() {
  const [searchQuery, setSearchQuery] = useState('');
  const [results, setResults] = useState([]);
  const [isSearching, setIsSearching] = useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const [user, setUser] = useState<FirebaseUser | null>(null);
  const [isProfileOpen, setIsProfileOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const profileRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
    });
    return () => unsubscribe();
  }, []);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsDropdownOpen(false);
      }
      if (profileRef.current && !profileRef.current.contains(event.target as Node)) {
        setIsProfileOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  useEffect(() => {
    const delayDebounceFn = setTimeout(async () => {
      if (searchQuery.length > 2) {
        setIsSearching(true);
        setIsDropdownOpen(true);
        try {
          const token = await auth.currentUser?.getIdToken();
          if (!token) return;
          const data = await searchContent(searchQuery, token);
          setResults(data.results.filter((item: any) => item.media_type !== 'person').slice(0, 8));
        } catch (error) {
          console.error('Search failed:', error);
        } finally {
          setIsSearching(false);
        }
      } else {
        setResults([]);
        setIsDropdownOpen(false);
      }
    }, 500);

    return () => clearTimeout(delayDebounceFn);
  }, [searchQuery]);

  const handleLogin = async () => {
    try {
      await signInWithPopup(auth, googleProvider);
    } catch (error) {
      console.error('Login failed:', error);
    }
  };

  const handleLogout = async () => {
    try {
      await signOut(auth);
      setIsProfileOpen(false);
    } catch (error) {
      console.error('Logout failed:', error);
    }
  };

  return (
    <nav className="fixed top-0 w-full z-100 bg-black/80 backdrop-blur-md border-b border-white/10 px-4 py-3 flex items-center justify-between">
      <div className="flex items-center gap-8">
        <Link href="/" className="flex items-center gap-2">
          <img
            src="/assets/images/logo.png"
            alt="Cinemanic Logo"
            className="object-contain w-12"
          />
        </Link>
      </div>

      <div className="flex-1 max-w-2xl mx-4 relative" ref={dropdownRef}>
        <div className="relative group">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-white/50 w-5 h-5 group-focus-within:text-blue-500 transition-colors" />
          <input
            type="text"
            placeholder="Search movies, shows..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full bg-white/10 border border-transparent focus:border-blue-500 focus:bg-white/15 rounded-full py-2 pl-10 pr-10 text-white placeholder:text-white/40 outline-none transition-all"
          />
          {searchQuery && (
            <button 
              onClick={() => setSearchQuery('')}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-white/50 hover:text-white"
            >
              <X className="w-4 h-4" />
            </button>
          )}
        </div>

        <AnimatePresence>
          {isDropdownOpen && (searchQuery.length > 2) && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: 10 }}
              className="absolute top-full left-0 right-0 mt-2 bg-[#1a1a1a] border border-white/10 rounded-2xl overflow-hidden shadow-2xl z-110"
            >
              <div className="max-h-[70vh] overflow-y-auto no-scrollbar">
                {isSearching ? (
                  <div className="p-8 text-center text-white/50">Searching...</div>
                ) : results.length > 0 ? (
                  <div className="flex flex-col">
                    {results.map((item: any) => (
                      <Link 
                        key={item.id} 
                        href={`/content/${item.media_type}/${item.id}`}
                        onClick={() => setIsDropdownOpen(false)}
                        className="flex items-center gap-4 p-3 hover:bg-white/5 transition-colors group"
                      >
                        <div className="relative w-12 h-16 rounded overflow-hidden shrink-0">
                          <Image
                            src={imageUrlBuilder(item.poster_path)}
                            alt={item.title || item.name}
                            fill
                            className="object-cover"
                          />
                        </div>
                        <div className="flex flex-col gap-1 overflow-hidden">
                          <span className="text-white font-medium truncate">
                            {item.title || item.name}
                          </span>
                          <div className="flex items-center gap-2 text-xs text-white/50">
                            {item.media_type === 'movie' ? (
                              <Film className="w-3 h-3 text-blue-500" />
                            ) : (
                              <Tv className="w-3 h-3 text-green-500" />
                            )}
                            <span className="capitalize">{item.media_type}</span>
                            {item.release_date && (
                              <span>• {item.release_date.split('-')[0]}</span>
                            )}
                          </div>
                        </div>
                      </Link>
                    ))}
                  </div>
                ) : (
                  <div className="p-8 text-center text-white/50">No results found for "{searchQuery}"</div>
                )}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      <div className="flex items-center gap-4 shrink-0">
        {user ? (
          <div className="relative" ref={profileRef}>
            <button 
              onClick={() => setIsProfileOpen(!isProfileOpen)}
              className="relative w-10 h-10 rounded-full overflow-hidden border-2 border-transparent hover:border-blue-500 transition-all active:scale-95"
            >
              <Image
                src={user.photoURL || '/assets/images/google_logo.png'}
                alt={user.displayName || 'User'}
                fill
                className="object-cover"
              />
            </button>

            <AnimatePresence>
              {isProfileOpen && (
                <motion.div
                  initial={{ opacity: 0, y: 10, scale: 0.95 }}
                  animate={{ opacity: 1, y: 0, scale: 1 }}
                  exit={{ opacity: 0, y: 10, scale: 0.95 }}
                  className="absolute top-full right-0 mt-3 w-64 bg-[#1a1a1a] border border-white/10 rounded-2xl overflow-hidden shadow-2xl z-120"
                >
                  <div className="p-4 border-b border-white/10 flex flex-col items-center text-center">
                    <div className="relative w-16 h-16 rounded-full overflow-hidden mb-3">
                      <Image
                        src={user.photoURL || '/assets/images/google_logo.png'}
                        alt={user.displayName || 'User'}
                        fill
                        className="object-cover"
                      />
                    </div>
                    <p className="text-white font-bold">{user.displayName}</p>
                    <p className="text-white/50 text-xs truncate w-full">{user.email}</p>
                  </div>
                  <div className="p-2">
                    <Link 
                      href="/profile" 
                      onClick={() => setIsProfileOpen(false)}
                      className="flex items-center gap-3 w-full p-3 hover:bg-white/5 text-white/80 hover:text-white rounded-xl transition-colors"
                    >
                      <User className="w-5 h-5 text-blue-500" />
                      <span>My Profile</span>
                    </Link>
                    <button 
                      onClick={handleLogout}
                      className="flex items-center gap-3 w-full p-3 hover:bg-red-500/10 text-red-500 rounded-xl transition-colors mt-2"
                    >
                      <LogOut className="w-5 h-5" />
                      <span>Sign Out</span>
                    </button>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        ) : (
          <button 
            onClick={handleLogin}
            className="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-lg shadow-blue-600/20 active:scale-95 transition-all whitespace-nowrap"
          >
            <User className="w-5 h-5" />
            <span className="hidden sm:inline">Sign In</span>
          </button>
        )}
      </div>
    </nav>
  );
}
