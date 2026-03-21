import { db } from "@/db";
import { watchList } from "@/db/schema";
import { verifyFirebaseUser } from "@/lib/auth";
import { and, desc, eq } from "drizzle-orm";
import { NextRequest, NextResponse } from "next/server";

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

    const history = await db.select().from(watchList)
      .where(eq(watchList.userId, userId))
      .orderBy(desc(watchList.updatedAt));

    return NextResponse.json(history);
  } catch (error) {
    console.error("Error fetching watch history:", error);
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
      return db.insert(watchList).values({
        userId,
        mediaId: item.id,
        type: item.type,
        title: item.title,
        posterPath: item.poster_path,
        backdropPath: item.backdrop_path,
        updatedAt: new Date(item.last_updated || Date.now()),
      }).onConflictDoUpdate({
        target: [watchList.userId, watchList.mediaId],
        set: {
          updatedAt: new Date(item.last_updated || Date.now()),
        }
      });
    });

    await Promise.all(upserts);

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Error saving watchlist:", error);
    return NextResponse.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

export async function DELETE(req: NextRequest) {
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

        const deletes = Object.values(mediaDataMap).map((item: any) => {
            return db.delete(watchList).where(
                and(
                    eq(watchList.userId, userId),
                    eq(watchList.mediaId, item.id)
                )
            );
        });

        await Promise.all(deletes);

        return NextResponse.json({ success: true });
    } catch (error) {
        console.error("Error saving watchlist:", error);
        return NextResponse.json({ error: "Internal Server Error" }, { status: 500 });
    }
}
