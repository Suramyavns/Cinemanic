'use client';

import { useState, useEffect, use } from 'react';
import Image from 'next/image';
import { fetchPersonDetails } from '@/services/tmdb';
import { imageUrlBuilder } from '@/lib/images';
import { auth } from '@/lib/firebase';
import MediaRow from '@/components/MediaRow';
import ContentModal from '@/components/ContentModal';
import { Calendar, MapPin, User as UserIcon } from 'lucide-react';

export default function PersonDetailsPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const [person, setPerson] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [selectedContent, setSelectedContent] = useState<{id: number, type: string} | null>(null);

  useEffect(() => {
    async function loadData() {
      try {
        const user = auth.currentUser;
        if (!user) return;
        const token = await user.getIdToken();
        const data = await fetchPersonDetails(id, token);
        setPerson(data);
      } catch (error) {
        console.error('Failed to fetch person details:', error);
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

  if (!person) return (
    <div className="min-h-screen flex items-center justify-center text-white/50">
      Person not found.
    </div>
  );

  const credits = person.combined_credits?.cast || [];

  return (
    <div className="min-h-screen pb-20">
      {/* Header */}
      <div className="relative pt-10 pb-12 px-4 md:px-16 flex flex-col md:flex-row gap-8 md:gap-12 items-center md:items-start bg-linear-to-b from-white/5 to-transparent">
        <div className="relative w-48 h-48 md:w-64 md:h-64 rounded-2xl overflow-hidden shadow-2xl shrink-0 border border-white/10">
          <Image
            src={imageUrlBuilder(person.profile_path)}
            alt={person.name}
            fill
            className="object-cover"
          />
        </div>
        
        <div className="flex-1 space-y-6 text-center md:text-left">
          <div className="space-y-2">
            <h1 className="text-4xl md:text-6xl font-black text-white tracking-tighter">
              {person.name}
            </h1>
            <p className="text-blue-500 font-bold text-lg uppercase tracking-widest">
              {person.known_for_department}
            </p>
          </div>

          <div className="flex flex-wrap justify-center md:justify-start gap-6 text-white/70">
            {person.birthday && (
              <div className="flex items-center gap-2">
                <Calendar className="w-5 h-5" />
                <span>Born {new Date(person.birthday).toLocaleDateString()}</span>
              </div>
            )}
            {person.place_of_birth && (
              <div className="flex items-center gap-2">
                <MapPin className="w-5 h-5" />
                <span>{person.place_of_birth}</span>
              </div>
            )}
          </div>

          {person.biography && (
            <div className="space-y-3">
              <h3 className="text-white/50 text-xs font-bold uppercase tracking-widest text-center md:text-left">Biography</h3>
              <p className="text-white/80 leading-relaxed line-clamp-6 md:line-clamp-none max-w-4xl">
                {person.biography}
              </p>
            </div>
          )}
        </div>
      </div>

      {/* Credits */}
      <div className="mt-8 space-y-12">
        <MediaRow 
          title="Known For" 
          data={credits.slice(0, 20).sort((a: any, b: any) => b.popularity - a.popularity)} 
          mediaType="movie" 
          onCardClick={(id, type) => setSelectedContent({ id, type })}
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
