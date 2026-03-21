// ============================================================
// Media Response Models
// Generated from TMDB /trending API response
// ============================================================

import { MediaType } from "./TMDBModels";


// ─── MediaItem ───────────────────────────────────────────────

export interface MediaItem {
  adult: boolean;
  backdropPath?: string;
  id: number;
  /** Unified display title — covers both `title` (movie) and `name` (TV) */
  title: string;
  originalLanguage: string;
  /** Covers both `original_title` (movie) and `original_name` (TV) */
  originalTitle: string;
  overview: string;
  posterPath?: string;
  mediaType: MediaType;
  genreIds: number[];
  popularity: number;
  releaseDate?: string;   // movies
  firstAirDate?: string;  // TV shows
  video?: boolean;
  voteAverage: number;
  voteCount: number;
  originCountry?: string[]; // TV shows only
}

export const isMovie = (m: MediaItem): boolean => m.mediaType === MediaType.Movie;
export const isTvShow = (m: MediaItem): boolean => m.mediaType === MediaType.Tv;

export function mediaItemFromJson(json: Record<string, unknown>): MediaItem {
  const mediaTypeStr = json["media_type"] as string | undefined;
  const mediaType =
    mediaTypeStr === "movie"
      ? MediaType.Movie
      : mediaTypeStr === "tv"
      ? MediaType.Tv
      : MediaType.Unknown;

  return {
    adult: json["adult"] as boolean,
    backdropPath: json["backdrop_path"] as string | undefined,
    id: json["id"] as number,
    title: ((json["title"] ?? json["name"] ?? "") as string),
    originalLanguage: json["original_language"] as string,
    originalTitle: ((json["original_title"] ?? json["original_name"] ?? "") as string),
    overview: json["overview"] as string,
    posterPath: json["poster_path"] as string | undefined,
    mediaType,
    genreIds: (json["genre_ids"] as number[]),
    popularity: (json["popularity"] as number),
    releaseDate: json["release_date"] as string | undefined,
    firstAirDate: json["first_air_date"] as string | undefined,
    video: json["video"] as boolean | undefined,
    voteAverage: (json["vote_average"] as number),
    voteCount: json["vote_count"] as number,
    originCountry: json["origin_country"] as string[] | undefined,
  };
}

export function mediaItemToJson(m: MediaItem): Record<string, unknown> {
  const movie = isMovie(m);
  const tv = isTvShow(m);

  return {
    adult: m.adult,
    ...(m.backdropPath !== undefined && { backdrop_path: m.backdropPath }),
    id: m.id,
    ...(movie ? { title: m.title } : { name: m.title }),
    original_language: m.originalLanguage,
    ...(movie ? { original_title: m.originalTitle } : { original_name: m.originalTitle }),
    overview: m.overview,
    ...(m.posterPath !== undefined && { poster_path: m.posterPath }),
    media_type: movie ? "movie" : tv ? "tv" : "unknown",
    genre_ids: m.genreIds,
    popularity: m.popularity,
    ...(m.releaseDate !== undefined && { release_date: m.releaseDate }),
    ...(m.firstAirDate !== undefined && { first_air_date: m.firstAirDate }),
    ...(m.video !== undefined && { video: m.video }),
    vote_average: m.voteAverage,
    vote_count: m.voteCount,
    ...(m.originCountry !== undefined && { origin_country: m.originCountry }),
  };
}

// ─── TrendingDataClass ───────────────────────────────────────

export interface TrendingDataClass {
  page: number;
  results: MediaItem[];
  totalPages: number;
  totalResults: number;
}

export function trendingDataClassFromJson(json: Record<string, unknown>): TrendingDataClass {
  return {
    page: json["page"] as number,
    results: (json["results"] as Record<string, unknown>[]).map(mediaItemFromJson),
    totalPages: json["total_pages"] as number,
    totalResults: json["total_results"] as number,
  };
}

export function trendingDataClassToJson(t: TrendingDataClass): Record<string, unknown> {
  return {
    page: t.page,
    results: t.results.map(mediaItemToJson),
    total_pages: t.totalPages,
    total_results: t.totalResults,
  };
}