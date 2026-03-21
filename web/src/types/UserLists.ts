// ============================================================
// Watch History & Watchlist Models
// ============================================================

// ─── WatchHistoryItem ────────────────────────────────────────

export interface WatchHistoryItem {
  id: number;
  type: string;
  title: string;
  posterPath: string;
}

export function watchHistoryItemFromJson(json: Record<string, unknown>): WatchHistoryItem {
  return {
    id: json["mediaId"] as number,
    type: json["type"] as string,
    title: json["title"] as string,
    posterPath: (json["posterPath"] as string | undefined) ?? "",
  };
}

// ─── WatchList ───────────────────────────────────────────────

export interface WatchList {
  mediaId: number;
  /** 'movie' or 'tv' */
  type: string;
  title: string;
  posterPath?: string;
  backdropPath?: string;
}

export function watchListFromJson(json: Record<string, unknown>): WatchList {
  return {
    mediaId: Math.trunc(json["mediaId"] as number),
    type: json["type"] as string,
    title: json["title"] as string,
    posterPath: json["posterPath"] as string | undefined,
    backdropPath: json["backdropPath"] as string | undefined,
  };
}

export function watchListToJson(w: WatchList): Record<string, unknown> {
  return {
    media_id: w.mediaId,
    type: w.type,
    title: w.title,
    poster_path: w.posterPath,
    backdrop_path: w.backdropPath,
  };
}