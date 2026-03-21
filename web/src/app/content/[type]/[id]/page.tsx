'use client';

import { use } from 'react';
import ContentModal from '@/components/ContentModal';
import { useRouter } from 'next/navigation';

export default function ContentPage({ params }: { params: Promise<{ type: string, id: string }> }) {
  const { type, id } = use(params);
  const router = useRouter();

  return (
    <div className="min-h-screen bg-black">
      <ContentModal
        contentId={parseInt(id)}
        mediaType={type}
        onClose={() => router.back()}
      />
    </div>
  );
}
