import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/db';
import { watchHistory } from '@/db/schema';
import { verifyFirebaseUser } from '@/lib/auth';
import { sql, eq, and } from 'drizzle-orm';

export async function GET(req: NextRequest) {
  try {
    const authHeader = req.headers.get("authorization");
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const token = authHeader.split(" ")[1];
    let userId: string;
    try {
      userId = await verifyFirebaseUser({ token });
    } catch (error) {
      return NextResponse.json({ error: "Invalid token" }, { status: 401 });
    }

    const mediaId = req.nextUrl.searchParams.get("mediaId");
    if (!mediaId) {
      return NextResponse.json({ error: "Media ID required" }, { status: 400 });
    }

    const history = await db.select().from(watchHistory).where(
      and(
        eq(watchHistory.userId, userId),
        eq(watchHistory.mediaId, parseInt(mediaId))
      )
    ).limit(1);

    return NextResponse.json(history[0] || null);
  } catch (error) {
    console.error("Error fetching watch progress:", error);
    return NextResponse.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

export async function POST(req: NextRequest) {
  try {
    const authHeader = req.headers.get("authorization");
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const token = authHeader.split(" ")[1];
    let userId: string;
    try {
      userId = await verifyFirebaseUser({ token });
    } catch (error) {
      return NextResponse.json({ error: "Invalid token" }, { status: 401 });
    }

    const body = await req.json();
    const mediaDataMap = body.mediaData;

    if (!mediaDataMap || typeof mediaDataMap !== 'object') {
      return NextResponse.json({ error: "Invalid data format" }, { status: 400 });
    }

    const upserts = Object.values(mediaDataMap).map((item: any) => {
      return db.insert(watchHistory).values({
        userId,
        mediaId: item.id,
        type: item.type,
        title: item.title,
        posterPath: item.poster_path,
        backdropPath: item.backdrop_path,
        progress: item.progress,
        lastSeasonWatched: item.last_season_watched,
        lastEpisodeWatched: item.last_episode_watched,
        showProgress: item.show_progress,
        updatedAt: new Date(item.last_updated || Date.now()),
      }).onConflictDoUpdate({
        target: [watchHistory.userId, watchHistory.mediaId],
        set: {
          progress: item.progress,
          lastSeasonWatched: item.last_season_watched,
          lastEpisodeWatched: item.last_episode_watched,
          showProgress: item.show_progress,
          updatedAt: new Date(item.last_updated || Date.now()),
        }
      });
    });

    await Promise.all(upserts);

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Error saving watch progress:", error);
    return NextResponse.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
