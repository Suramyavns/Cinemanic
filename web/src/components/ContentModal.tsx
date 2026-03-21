'use client';

import { useState, useEffect } from 'react';
import Image from 'next/image';
import { X, Play, Plus, Check, Star, Clock, Globe } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { fetchMovieDetails, fetchShowDetails, fetchSeasonDetails } from '@/services/tmdb';
import { imageUrlBuilder } from '@/lib/images';
import { auth } from '@/lib/firebase';
import { useRouter } from 'next/navigation';
import PersonCard from './PersonCard';
import MediaRow from './MediaRow';
import { ChevronDown, ChevronRight, Calendar, Info } from 'lucide-react';

interface ContentModalProps {
  contentId: number;
  mediaType: string;
  onClose: () => void;
}

export default function ContentModal({ contentId, mediaType, onClose }: ContentModalProps) {
  const router = useRouter();
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [isInWatchlist, setIsInWatchlist] = useState(false);
  const [isUpdatingWatchlist, setIsUpdatingWatchlist] = useState(false);
  const [watchProgress, setWatchProgress] = useState<any>(null);
  const [selectedSeason, setSelectedSeason] = useState<number>(1);
  const [episodes, setEpisodes] = useState<any[]>([]);
  const [loadingEpisodes, setLoadingEpisodes] = useState(false);
  const [showSeasonDropdown, setShowSeasonDropdown] = useState(false);

  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      try {
        const user = auth.currentUser;
        if (!user) return;
        const token = await user.getIdToken();

        const details = mediaType === 'movie' 
          ? await fetchMovieDetails(contentId.toString(), token)
          : await fetchShowDetails(contentId.toString(), token);
        setData(details);
        
        // Fetch watch progress
        const progRes = await fetch(`/api/watch/progress?mediaId=${contentId}`, {
          headers: { 'Authorization': `Bearer ${token}` }
        });
        const prog = await progRes.json();
        setWatchProgress(prog);

        // Check watchlist status
        const wlRes = await fetch('/api/watchlist', {
          headers: { 'Authorization': `Bearer ${token}` }
        });
        const list = await wlRes.json();
        if (Array.isArray(list)) {
          setIsInWatchlist(list.some(item => item.mediaId === contentId));
        }

        // If TV show, select season based on history or first available
        if (mediaType === 'tv' && details.seasons?.length > 0) {
          let seasonToSelect = details.seasons.find((s: any) => s.season_number > 0)?.season_number || 1;
          
          if (prog?.lastSeasonWatched) {
            const historySeason = parseInt(prog.lastSeasonWatched);
            if (!isNaN(historySeason)) {
              seasonToSelect = historySeason;
            }
          }
          
          setSelectedSeason(seasonToSelect);
          fetchEpisodes(seasonToSelect, token);
        }
      } catch (error) {
        console.error('Failed to load content details:', error);
      } finally {
        setLoading(false);
      }
    };
    loadData();
  }, [contentId, mediaType]);

  const fetchEpisodes = async (seasonNum: number, token?: string) => {
    setLoadingEpisodes(true);
    try {
      const authToken = token || await auth.currentUser?.getIdToken();
      if (!authToken) return;
      const seasonData = await fetchSeasonDetails(contentId.toString(), seasonNum, authToken);
      setEpisodes(seasonData.episodes || []);
    } catch (error) {
      console.error('Failed to fetch episodes:', error);
    } finally {
      setLoadingEpisodes(false);
    }
  };

  const handleSeasonChange = (seasonNum: number) => {
    setSelectedSeason(seasonNum);
    setShowSeasonDropdown(false);
    fetchEpisodes(seasonNum);
  };

  const isAnime = (content: any) => {
    return content?.genres?.some((g: any) => g.name.toLowerCase() === 'animation' || g.name.toLowerCase() === 'anime') || 
           content?.original_language === 'ja';
  };

  const handlePlay = async (episode?: number, season?: number) => {
    const user = auth.currentUser;
    if (!user) return;
    const token = await user.getIdToken();
    
    let path = `/${mediaType}/${contentId}`;
    if (mediaType === 'tv') {
      const s = season || watchProgress?.lastSeasonWatched || selectedSeason || 1;
      const e = episode || watchProgress?.lastEpisodeWatched || 1;
      path += `/${s}/${e}`;
    }

    const startAt = watchProgress?.progress?.watched || 0;
    const animeFlag = isAnime(data) ? '&isAnime=true' : '';
    const query = `?token=${token}${startAt > 0 ? `&startAt=${startAt}` : ''}${animeFlag}`;
    
    router.push(`${path}${query}`);
  };

  const getPlayButtonText = () => {
    if (!watchProgress) return "Play Now";
    if (mediaType === 'movie') return "Continue Watching";
    
    const season = watchProgress.lastSeasonWatched;
    const episode = watchProgress.lastEpisodeWatched;
    if (season && episode) return `Continue S${season}:E${episode}`;
    return "Play Now";
  };

  const toggleWatchlist = async () => {
    if (!auth.currentUser) {
      alert('Please sign in to manage your watchlist');
      return;
    }

    setIsUpdatingWatchlist(true);
    try {
      const token = await auth.currentUser.getIdToken();
      const method = isInWatchlist ? 'DELETE' : 'POST';
      const res = await fetch('/api/watchlist', {
        method,
        headers: { 
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          mediaData: {
            [contentId]: {
              id: contentId,
              type: mediaType,
              title: data.title || data.name,
              poster_path: data.poster_path,
              backdrop_path: data.backdrop_path,
            }
          }
        })
      });

      if (res.ok) {
        setIsInWatchlist(!isInWatchlist);
      }
    } catch (error) {
      console.error('Failed to update watchlist:', error);
    } finally {
      setIsUpdatingWatchlist(false);
    }
  };

  if (!contentId) return null;

  return (
    <AnimatePresence>
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="fixed inset-0 z-200 flex items-center justify-center p-4 md:p-8 bg-black/90 backdrop-blur-sm"
        onClick={onClose}
      >
        <motion.div
          initial={{ scale: 0.9, opacity: 0, y: 20 }}
          animate={{ scale: 1, opacity: 1, y: 0 }}
          exit={{ scale: 0.9, opacity: 0, y: 20 }}
          className="relative w-full px-4 max-w-5xl max-h-[90vh] bg-[#141414] rounded-2xl overflow-hidden shadow-2xl flex flex-col no-scrollbar overflow-y-auto"
          onClick={(e) => e.stopPropagation()}
        >
          {loading ? (
            <div className="h-[60vh] flex items-center justify-center">
              <div className="w-12 h-12 border-4 border-blue-500 border-t-transparent rounded-full animate-spin" />
            </div>
          ) : data ? (
            <>
              {/* Banner Section */}
              <div className="relative h-[50vh] md:h-[75vh] shrink-0">
                <Image
                  src={`https://image.tmdb.org/t/p/original${data.backdrop_path}`}
                  alt={data.title || data.name}
                  fill
                  className="object-cover"
                />
                <div className="absolute inset-0 bg-linear-to-t from-[#141414] via-[#141414]/20 to-transparent" />
                <button
                  onClick={onClose}
                  className="absolute top-4 right-4 p-2 bg-black/50 hover:bg-black/80 rounded-full text-white transition-colors"
                >
                  <X className="w-6 h-6" />
                </button>

                <div className="absolute bottom-0 left-0 p-6 md:p-10 w-full flex flex-col gap-4">
                  <h2 className="text-3xl md:text-5xl font-bold text-white uppercase tracking-tight">
                    {data.title || data.name}
                  </h2>
                  <div className="flex flex-wrap items-center gap-4 text-sm font-medium">
                    <div className="flex items-center gap-1 text-yellow-500">
                      <Star className="w-4 h-4 fill-current" />
                      <span>{data.vote_average?.toFixed(1)}</span>
                    </div>
                    <div className="flex items-center gap-1 text-white/70">
                      <Clock className="w-4 h-4" />
                      <span>{data.runtime || data.episode_run_time?.[0] || 'N/A'} min</span>
                    </div>
                    <div className="flex items-center gap-1 text-white/70">
                      <Globe className="w-4 h-4" />
                      <span className="uppercase">{data.original_language}</span>
                    </div>
                    <span className="text-blue-500 font-bold capitalize">{mediaType}</span>
                  </div>
                  <div className="flex flex-wrap items-center gap-4 mt-2">
                    <button 
                      onClick={() => handlePlay()}
                      className="flex items-center gap-2 bg-white text-black font-bold py-2.5 px-8 rounded-lg hover:bg-white/90 transition-all active:scale-95 shadow-lg"
                    >
                      <Play className="w-5 h-5 fill-current" />
                      <span>{getPlayButtonText()}</span>
                    </button>
                    <button 
                      onClick={toggleWatchlist}
                      disabled={isUpdatingWatchlist}
                      className={`flex items-center gap-2 py-2.5 px-6 rounded-lg transition-all border font-bold active:scale-95 shadow-lg ${
                        isInWatchlist 
                          ? 'bg-blue-600 border-blue-600 text-white' 
                          : 'bg-white/10 hover:bg-white/20 border-white/10 text-white'
                      }`}
                    >
                      {isInWatchlist ? (
                        <>
                          <Check className="w-5 h-5" />
                          <span>In Watchlist</span>
                        </>
                      ) : (
                        <>
                          <Plus className="w-5 h-5" />
                          <span>Watchlist</span>
                        </>
                      )}
                    </button>
                  </div>
                </div>
              </div>

              {/* Details Section */}
              <div className="p-6 md:p-10 flex flex-col gap-10">
                <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                  <div className="md:col-span-2 space-y-6">
                    <div>
                      <h3 className="text-white/50 text-xs font-bold uppercase tracking-widest mb-2">Overview</h3>
                      <p className="text-white/90 text-lg leading-relaxed">
                        {data.overview}
                      </p>
                    </div>
                    
                    <div className="flex flex-wrap gap-2">
                      {data.genres?.map((genre: any) => (
                        <span key={genre.id} className="bg-white/5 border border-white/10 px-3 py-1 rounded text-sm text-white/70">
                          {genre.name}
                        </span>
                      ))}
                    </div>
                  </div>

                    <div className="flex flex-col gap-6 bg-white/5 p-6 rounded-2xl border border-white/10">
                      <div>
                        <h3 className="text-white/50 text-xs font-bold uppercase tracking-widest mb-2">TMDB Rating</h3>
                        <div className="flex items-center gap-2 text-2xl font-bold text-white">
                          <Star className="w-6 h-6 text-yellow-500 fill-current" />
                          <span>{data.vote_average?.toFixed(1)}</span>
                          <span className="text-white/30 text-sm font-normal">/ 10</span>
                        </div>
                      </div>
                      <div>
                        <h3 className="text-white/50 text-xs font-bold uppercase tracking-widest mb-2">Status</h3>
                        <p className="text-white font-medium">{data.status}</p>
                      </div>
                      {data.first_air_date && (
                        <div>
                          <h3 className="text-white/50 text-xs font-bold uppercase tracking-widest mb-2">First Aired</h3>
                          <p className="text-white font-medium">{new Date(data.first_air_date).toLocaleDateString()}</p>
                        </div>
                      )}
                    </div>
                  </div>
                </div>

                {/* TV Seasons & Episodes Selection */}
                {mediaType === 'tv' && data.seasons && (
                  <div className="flex flex-col gap-6">
                    <div className="flex items-center justify-between">
                      <h3 className="text-white text-xl font-bold flex items-center gap-2">
                        <span className="w-1 h-6 bg-blue-600 rounded-full" />
                        Episodes
                      </h3>
                      
                      {/* Season Dropdown */}
                      <div className="relative">
                        <button 
                          onClick={() => setShowSeasonDropdown(!showSeasonDropdown)}
                          className="flex items-center gap-2 bg-white/5 border border-white/10 px-4 py-2 rounded-lg text-white font-bold hover:bg-white/10 transition-all"
                        >
                          Season {selectedSeason}
                          <ChevronDown className={`w-4 h-4 transition-transform ${showSeasonDropdown ? 'rotate-180' : ''}`} />
                        </button>
                        
                        {showSeasonDropdown && (
                          <div className="absolute right-0 mt-2 w-48 bg-[#1f1f1f] border border-white/10 rounded-xl shadow-2xl z-210 overflow-hidden">
                            <div className="max-h-60 overflow-y-auto no-scrollbar">
                              {data.seasons
                                .filter((s: any) => s.season_number > 0)
                                .map((s: any) => (
                                  <button
                                    key={s.id}
                                    onClick={() => handleSeasonChange(s.season_number)}
                                    className={`w-full text-left px-4 py-3 hover:bg-white/5 transition-colors text-sm font-medium ${
                                      selectedSeason === s.season_number ? 'text-blue-500 bg-blue-500/5' : 'text-white/70'
                                    }`}
                                  >
                                    Season {s.season_number}
                                    <span className="ml-2 text-xs text-white/30">({s.episode_count} Episodes)</span>
                                  </button>
                                ))}
                            </div>
                          </div>
                        )}
                      </div>
                    </div>

                    <div className="flex flex-col gap-4">
                      {loadingEpisodes ? (
                        <div className="py-10 flex justify-center">
                          <div className="w-8 h-8 border-3 border-blue-500 border-t-transparent rounded-full animate-spin" />
                        </div>
                      ) : (
                        episodes.map((episode: any) => (
                          <div 
                            key={episode.id}
                            onClick={() => handlePlay(episode.episode_number, selectedSeason)}
                            className="group flex flex-col md:flex-row gap-4 p-4 bg-white/5 border border-white/10 rounded-xl hover:bg-white/10 transition-all cursor-pointer active:scale-[0.99]"
                          >
                            <div className="relative w-full md:w-48 aspect-video rounded-lg overflow-hidden shrink-0">
                              <Image
                                src={imageUrlBuilder(episode.still_path || data.backdrop_path)}
                                alt={episode.name}
                                fill
                                className="object-cover group-hover:scale-105 transition-transform duration-500"
                              />
                              <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                                <Play className="w-8 h-8 text-white fill-current" />
                              </div>
                              <div className="absolute bottom-2 right-2 bg-black/70 px-2 py-0.5 rounded text-[10px] font-bold text-white">
                                Episode {episode.episode_number}
                              </div>
                            </div>
                            
                            <div className="flex flex-col gap-2 grow">
                              <div className="flex items-center justify-between">
                                <h4 className="text-white font-bold text-lg group-hover:text-blue-500 transition-colors">
                                  {episode.episode_number}. {episode.name}
                                </h4>
                                {episode.air_date && (
                                  <div className="flex items-center gap-1 text-white/30 text-xs">
                                    <Calendar className="w-3 h-3" />
                                    {new Date(episode.air_date).getFullYear()}
                                  </div>
                                )}
                              </div>
                              <p className="text-white/60 text-sm line-clamp-2 leading-relaxed">
                                {episode.overview || "No overview available for this episode."}
                              </p>
                            </div>
                          </div>
                        ))
                      )}
                    </div>
                  </div>
                )}

                {/* Cast Section */}
                <div>
                  <h3 className="text-white text-xl font-bold my-6 flex items-center gap-2">
                    <span className="w-1 h-6 bg-blue-600 rounded-full" />
                    Top Cast
                  </h3>
                  <div className="flex gap-6 overflow-x-auto no-scrollbar pb-4">
                    {data.credits?.cast?.slice(0, 10).map((person: any) => (
                      <PersonCard
                        key={person.id}
                        id={person.id}
                        name={person.name}
                        character={person.character}
                        profilePath={person.profile_path}
                      />
                    ))}
                  </div>
                </div>

                {/* Recommendations */}
                {data.recommendations?.results?.length > 0 && (
                  <div className="-mx-6 md:-mx-10">
                    <MediaRow
                      title="More Like This"
                      data={data.recommendations.results}
                      mediaType={mediaType}
                      onCardClick={() => {}} // Handle recursion if needed
                    />
                  </div>
                )}
            </>
          ) : (
            <div className="h-[60vh] flex items-center justify-center text-white/50">
              Failed to load data.
            </div>
          )}
        </motion.div>
      </motion.div>
    </AnimatePresence>
  );
}
