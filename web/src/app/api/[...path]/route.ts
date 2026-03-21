import { NextRequest, NextResponse } from "next/server";
import { verifyFirebaseUser } from "@/lib/auth";

export async function GET(
  req: NextRequest,
  { params }: { params: Promise<{ path: string[] }> }
) {
  try {
    const authHeader = req.headers.get("authorization");
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const token = authHeader.split(" ")[1];
    try {
        await verifyFirebaseUser({ token });
    } catch (error) {
        return NextResponse.json({ error: "Invalid token" }, { status: 401 });
    }

    const { path } = await params;
    // Handle case where user might include '3' in the path (e.g., /api/3/movie/popular)
    const filteredPath = path[0] === "3" ? path.slice(1) : path;
    const tmdbPath = filteredPath.join("/");
    
    const { searchParams } = new URL(req.url);
    const tmdbApiKey = process.env.TMDB_API_KEY;
    const tmdbBaseUrl = process.env.TMDB_BASE_URL;

    if (!tmdbApiKey || !tmdbBaseUrl) {
        return NextResponse.json({ error: "TMDB configuration missing" }, { status: 500 });
    }

    // TMDB v3 keys must be sent as a query parameter
    searchParams.set("api_key", tmdbApiKey);
    const tmdbUrl = `${tmdbBaseUrl}/3/${tmdbPath}?${searchParams.toString()}`;
    console.log("Proxying to TMDB:", tmdbUrl);

    const response = await fetch(tmdbUrl, {
      method: "GET",
      headers: {
        accept: "application/json",
      },
    });
    
    if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        console.error("TMDB Proxy Error Details:", {
            status: response.status,
            url: tmdbUrl,
            error: errorData
        });
        return NextResponse.json(errorData, { status: response.status });
    }

    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    console.error("TMDB Proxy Error:", error);
    return NextResponse.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
