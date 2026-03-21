import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/db';
import { watchHistory } from '@/db/schema';
import { verifyFirebaseUser } from '@/lib/auth';
import { eq, desc } from 'drizzle-orm';

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

    const history = await db.select().from(watchHistory)
      .where(eq(watchHistory.userId, userId))
      .orderBy(desc(watchHistory.updatedAt))
      .limit(10);

    return NextResponse.json(history);
  } catch (error) {
    console.error("Error fetching watch history:", error);
    return NextResponse.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
