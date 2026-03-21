import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(request: NextRequest) {

  // Handle CORS preflight — must return before auth check
  if (request.method === 'OPTIONS') {
    return new NextResponse(null, {
      status: 200,
      headers: {
        'Access-Control-Allow-Origin': process.env.CORS_ORIGIN ?? '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    });
  }

  const authHeader = request.headers.get("authorization");

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return NextResponse.json(
      { error: "Unauthorized: Missing Firebase token" },
      {
        status: 401,
        headers: {
          'Access-Control-Allow-Origin': process.env.CORS_ORIGIN ?? '*',
        },
      }
    );
  }

  // Attach CORS headers to the actual passing response
  const response = NextResponse.next();
  response.headers.set('Access-Control-Allow-Origin', process.env.CORS_ORIGIN ?? '*');
  response.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  response.headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  return response;
}

export const config = {
  matcher: ["/api/:path*"],
};