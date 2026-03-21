'use client';

import Image from 'next/image';
import Link from 'next/link';
import { imageUrlBuilder } from '@/lib/images';
import { motion } from 'framer-motion';

interface PersonCardProps {
  id: number;
  name: string;
  character?: string;
  profilePath: string | null;
}

export default function PersonCard({ id, name, character, profilePath }: PersonCardProps) {
  return (
    <Link href={`/person/${id}`} className="shrink-0 w-28 md:w-32 group">
      <motion.div
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
        className="relative aspect-square rounded-full overflow-hidden mb-3 border-2 border-transparent group-hover:border-blue-500 transition-all duration-300 shadow-lg shadow-black/20"
      >
        <Image
          src={imageUrlBuilder(profilePath)}
          alt={name}
          fill
          className="object-cover"
        />
      </motion.div>
      <div className="text-center overflow-hidden">
        <p className="text-white text-sm font-bold truncate group-hover:text-blue-500 transition-colors">
          {name}
        </p>
        {character && (
          <p className="text-white/50 text-xs truncate">
            {character}
          </p>
        )}
      </div>
    </Link>
  );
}
