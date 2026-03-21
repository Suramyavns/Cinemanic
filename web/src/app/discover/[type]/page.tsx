'use client';

import { useState, useEffect, use, useRef, useCallback, Suspense } from 'react';
import { useSearchParams } from 'next/navigation';
import ContentCard from '@/components/ContentCard';
import ContentModal from '@/components/ContentModal';
import { fetchPopularMovies, fetchPopularShows } from '@/services/tmdb';
import { imageUrlBuilder } from '@/lib/images';
import { auth } from '@/lib/firebase';
import { MediaItem } from '@/types/MediaItem';

function DiscoverContent({ type }: { type: string }) {
  const searchParams = useSearchParams();
  const title = searchParams.get('title') || 'Discover';
  
  const [data, setData] = useState<MediaItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [fetchingMore, setFetchingMore] = useState(false);
  const [page, setPage] = useState(1);
  const [hasMore, setHasMore] = useState(true);
  const [selectedContent, setSelectedContent] = useState<{id: number, type: string} | null>(null);
  
  const observer = useRef<IntersectionObserver | null>(null);
  const lastElementRef = useCallback((node: HTMLDivElement | null) => {
    if (loading || fetchingMore) return;
    if (observer.current) observer.current.disconnect();
    observer.current = new IntersectionObserver(entries => {
      if (entries[0].isIntersecting && hasMore) {
        setPage(prevPage => prevPage + 1);
      }
    });
    if (node) observer.current.observe(node);
  }, [loading, fetchingMore, hasMore]);

  // Initial load
  useEffect(() => {
    async function loadData() {
      setLoading(true);
      try {
        const user = auth.currentUser;
        if (!user) return;
        const token = await user.getIdToken();
        
        let results;
        if (type === 'movie') {
          results = await fetchPopularMovies(token, 1);
        } else {
          results = await fetchPopularShows(token, 1);
        }
        setData(results.results);
        setHasMore(results.page < results.total_pages);
        setPage(1);
        
        // Ensure scroll to top on initial load
        window.scrollTo(0, 0);
      } catch (error) {
        console.error('Failed to fetch discover data:', error);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, [type]);

  // Fetch more pages
  useEffect(() => {
    if (page === 1 || !hasMore) return;

    async function fetchMore() {
      setFetchingMore(true);
      try {
        const user = auth.currentUser;
        if (!user) return;
        const token = await user.getIdToken();
        
        let results;
        if (type === 'movie') {
          results = await fetchPopularMovies(token, page);
        } else {
          results = await fetchPopularShows(token, page);
        }
        
        setData(prev => {
          const combined = [...prev, ...results.results];
          const unique = Array.from(new Map(combined.map(item => [item.id, item])).values());
          return unique;
        });
        setHasMore(results.page < results.total_pages);
      } catch (error) {
        console.error('Failed to fetch more data:', error);
      } finally {
        setFetchingMore(false);
      }
    }
    fetchMore();
  }, [page, type]);

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  return (
    <div className="min-h-screen px-4 md:px-8 py-10">
      <div className="mb-10 text-center md:text-left">
        <h1 className="text-3xl md:text-5xl font-black text-white uppercase tracking-tighter">
          {title}
        </h1>
        <p className="text-white/50 font-medium mt-2">Browse the most popular {type === 'movie' ? 'movies' : 'TV shows'}</p>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4 md:gap-8">
        {data.map((item, index) => (
          <div 
            key={`${item.id}-${index}`} 
            ref={index === data.length - 1 ? lastElementRef : null}
            className="aspect-2/3 w-full flex justify-center"
          >
            <ContentCard
              imageSrc={imageUrlBuilder((item as any).poster_path || item.posterPath)}
              contentId={item.id}
              mediaType={type}
              onClick={(id, type) => setSelectedContent({ id, type })}
            />
          </div>
        ))}
      </div>

      {fetchingMore && (
        <div className="py-10 flex justify-center">
          <div className="w-8 h-8 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
        </div>
      )}

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

export default function DiscoverPage({ params }: { params: Promise<{ type: string }> }) {
  const { type } = use(params);
  
  return (
    <Suspense fallback={
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
      </div>
    }>
      <DiscoverContent type={type} />
    </Suspense>
  );
}
