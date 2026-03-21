'use client';

import { useState, useEffect } from "react";
import MediaRow from "@/components/MediaRow";
import ContentModal from "@/components/ContentModal";
import { fetchPopularMovies, fetchTrending, fetchTopRatedShows } from "@/services/tmdb";
import Image from "next/image";
import { Play, Info } from "lucide-react";
import { auth } from "@/lib/firebase";
import { TrendingDataClass } from "@/types/MediaItem";
import { PopularMoviesResponse, TopRatedTvResponse } from "@/types/TMDBModels";
import { WatchHistoryItem, WatchList } from "@/types/UserLists";

export default function HomePage() {
  const [trending, setTrending] = useState<TrendingDataClass | null>(null);
  const [popularMovies, setPopularMovies] = useState<PopularMoviesResponse | null>(null);
  const [topRatedShows, setTopRatedShows] = useState<TopRatedTvResponse | null>(null);
  const [watchlist, setWatchlist] = useState<WatchList[]>([]);
  const [watchHistory, setWatchHistory] = useState<WatchHistoryItem[]>([]);
  const [selectedContent, setSelectedContent] = useState<{id: number, type: string} | null>(null);

  const loadData = async () => {
    const user = auth.currentUser;
    if (!user) return;

    try {
      const token = await user.getIdToken();
      const [ta, pm, trs, wl, wh] = await Promise.all([
        fetchTrending(token),
        fetchPopularMovies(token),
        fetchTopRatedShows(token),
        fetch('/api/watchlist', { 
          headers: { 'Authorization': `Bearer ${token}` },
          cache: 'no-store'
        }).then(res => res.json()),
        fetch('/api/watch/history', { 
          headers: { 'Authorization': `Bearer ${token}` },
          cache: 'no-store' 
        }).then(res => res.json()),
      ]);

      setTrending(ta);
      setPopularMovies(pm);
      setTopRatedShows(trs);
      setWatchlist(Array.isArray(wl) ? wl.map((i: WatchList) => ({ ...i, id: i.mediaId, media_type: i.type })) : []);
      setWatchHistory(Array.isArray(wh) ? wh.map((i: WatchHistoryItem) => ({ ...i, id: i.id, media_type: i.type })) : []);
    } catch (error) {
      console.error('Failed to reload home data:', error);
    }
  };

  useEffect(() => {
    loadData();

    // Refresh when returning to the tab
    const handleFocus = () => loadData();
    window.addEventListener('focus', handleFocus);
    return () => window.removeEventListener('focus', handleFocus);
  }, []);

  if (!trending) return (
    <div className="h-screen flex items-center justify-center">
      <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  const heroContent = trending.results[0];
  const handleCardClick = (id: number, type: string) => {
    setSelectedContent({ id, type });
  };

  console.log(watchHistory,watchlist)

  return (
    <div className="flex flex-col gap-4 pb-20">
      {/* Hero Section */}
      <div className="relative h-[70vh] w-full">
        <Image
          src={`https://image.tmdb.org/t/p/original${(heroContent as any).backdrop_path ?? heroContent.backdropPath}`}
          alt={heroContent.title}
          fill
          priority
          className="object-cover"
        />
        <div className="absolute inset-0 bg-linear-to-t from-black via-black/20 to-transparent" />
        
        <div className="absolute bottom-0 left-0 p-8 md:p-16 w-full md:w-2/3 flex flex-col gap-4">
          <h1 className="text-4xl md:text-6xl font-bold text-white drop-shadow-2xl">
            {heroContent.title}
          </h1>
          <p className="text-lg text-white/80 line-clamp-3 max-w-xl drop-shadow-md">
            {heroContent.overview}
          </p>
          <div className="flex items-center gap-4 mt-2">
            <button 
              onClick={() => handleCardClick(heroContent.id, heroContent.mediaType)}
              className="flex items-center gap-2 bg-white text-black font-bold py-3 px-8 rounded-lg hover:bg-white/90 transition-all active:scale-95 shadow-xl"
            >
              <Play className="w-6 h-6 fill-current" />
              <span>Play Now</span>
            </button>
            <button 
              onClick={() => handleCardClick(heroContent.id, heroContent.mediaType)}
              className="flex items-center gap-2 bg-white/20 backdrop-blur-md text-white font-bold py-3 px-8 rounded-lg hover:bg-white/30 transition-all active:scale-95 border border-white/10"
            >
              <Info className="w-6 h-6" />
              <span>More Info</span>
            </button>
          </div>
        </div>
      </div>

      {/* Content Rows */}
      <div className="-mt-16 relative z-10 flex flex-col gap-2">
        <MediaRow 
          title="Continue Watching" 
          data={watchHistory} 
          mediaType="watchHistory" 
          onCardClick={handleCardClick}
        />
        <MediaRow 
          title="Trending" 
          data={trending.results} 
          mediaType="trending" 
          onCardClick={handleCardClick}
        />
        <MediaRow 
          title="Watchlist" 
          data={watchlist} 
          mediaType="watchlist" 
          onCardClick={handleCardClick}
        />
        <MediaRow 
          title="Blockbuster Movies" 
          data={popularMovies?.results || []} 
          mediaType="movie" 
          onCardClick={handleCardClick}
          viewMoreHref="/discover/movie?title=Blockbuster Movies"
        />
        <MediaRow 
          title="Top Rated Shows" 
          data={topRatedShows?.results || []} 
          mediaType="tv" 
          onCardClick={handleCardClick}
          viewMoreHref="/discover/tv?title=Top Rated Shows"
        />
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