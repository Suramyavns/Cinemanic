'use client';

import Image from 'next/image';
import { imageUrlBuilder } from '@/lib/images';
import { motion } from 'framer-motion';

interface ContentCardProps {
  imageSrc: string;
  contentId: number;
  mediaType: string;
  onClick?: (id: number, type: string) => void;
}

export default function ContentCard({ imageSrc, contentId, mediaType, onClick }: ContentCardProps) {
  return (
    <motion.div
      whileHover={{ scale: 1.05 }}
      whileTap={{ scale: 0.95 }}
      onClick={() => onClick?.(contentId, mediaType)}
      className="relative shrink-0 w-40 md:w-48 aspect-2/3 rounded-xl overflow-hidden cursor-pointer group shadow-lg hover:shadow-blue-500/20 transition-all duration-300"
    >
      <Image
        src={imageSrc || '/assets/images/banner.png'}
        alt={`Content ${contentId}`}
        fill
        sizes="(max-width: 768px) 160px, 192px"
        className="object-cover transition-transform duration-500 group-hover:scale-110"
      />
      <div className="absolute inset-0 bg-linear-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end p-4">
        <span className="text-white text-xs font-bold uppercase tracking-wider bg-blue-600 px-2 py-1 rounded">
          {mediaType}
        </span>
      </div>
    </motion.div>
  );
}
