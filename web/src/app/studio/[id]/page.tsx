'use client';

import { useState, useEffect, use } from 'react';
import ContentCard from '@/components/ContentCard';
import ContentModal from '@/components/ContentModal';
import { fetchStudioDetails } from '@/services/tmdb';
import { imageUrlBuilder } from '@/lib/images';
import { auth } from '@/lib/firebase';

export default function StudioDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const [data, setData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedContent, setSelectedContent] = useState<{id: number, type: string} | null>(null);

  useEffect(() => {
    async function loadData() {
      try {
        const user = auth.currentUser;
        if (!user) return;
        const token = await user.getIdToken();
        const movieData = await fetchStudioDetails(id, 'movie', token);
        const tvData = await fetchStudioDetails(id, 'tv', token);
        
        // Merge and sort by popularity
        const combined = [...movieData.results.map((i: any) => ({...i, media_type: 'movie'})), 
                          ...tvData.results.map((i: any) => ({...i, media_type: 'tv'}))];
        combined.sort((a: any, b: any) => b.popularity - a.popularity);
        
        setData(combined);
      } catch (error) {
        console.error('Failed to fetch studio details:', error);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, [id]);

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
    </div>
  );

  return (
    <div className="min-h-screen px-4 md:px-8 py-10">
      <div className="mb-10 text-center md:text-left">
        <h1 className="text-3xl md:text-5xl font-black text-white uppercase tracking-tighter">
          Studio Works
        </h1>
        <p className="text-white/50 font-medium mt-2">Discover productions from your favorite studios</p>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4 md:gap-8">
        {data.map((item) => (
          <div key={`${item.media_type}-${item.id}`} className="aspect-2/3 w-full">
            <ContentCard
              imageSrc={imageUrlBuilder(item.poster_path)}
              contentId={item.id}
              mediaType={item.media_type}
              onClick={(id, type) => setSelectedContent({ id, type })}
            />
          </div>
        ))}
      </div>

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
