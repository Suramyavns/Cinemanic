'use client';

import ContentCard from './ContentCard';
import { ChevronRight } from 'lucide-react';
import { imageUrlBuilder } from '@/lib/images';
import Link from 'next/link';
import { useState } from 'react';

interface MediaRowProps {
  title: string;
  data: any[];
  mediaType: string;
  onCardClick?: (id: number, type: string) => void;
  viewMoreHref?: string;
}

export default function MediaRow({ title, data, mediaType, onCardClick, viewMoreHref }: MediaRowProps) {
  if (!data || data.length === 0) return null;

  const sliceEnd = mediaType == 'watchlist'? 10: undefined;

  const getMediaType = (index: number) => {
    if(mediaType == 'trending'){
      return data[index].media_type;
    }
    else if(mediaType == 'watchlist' || mediaType == 'watchHistory'){
      return data[index].type;
    }
    else{
      return mediaType;
    }
  }

  return (
    <div className="py-6 px-4 md:px-8">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-xl md:text-2xl font-bold text-white tracking-tight">
          {title}
        </h2>
        {viewMoreHref && (
          <Link 
            href={viewMoreHref}
            className="flex items-center gap-1 text-sm font-medium text-white/50 hover:text-blue-500 transition-colors group"
          >
            <span>View More</span>
            <ChevronRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
          </Link>
        )}
      </div>

      <div className="flex gap-4 md:gap-6 overflow-x-auto no-scrollbar pb-4 -mx-4 px-4 md:-mx-8 md:px-8">
        {data.slice(0, sliceEnd).map((item, index) => (
          <ContentCard
            key={item.id}
            imageSrc={imageUrlBuilder(item.posterPath || item.poster_path)}
            contentId={item.mediaId || item.id}
            mediaType={getMediaType(index)}
            onClick={onCardClick}
          />
        ))}
      </div>
    </div>
  );
}
