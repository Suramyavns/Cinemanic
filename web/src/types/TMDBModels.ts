// ============================================================
// TMDB Search Response Models
// Generated from TMDB /search/multi API response
// ============================================================

export enum MediaType {
  Movie = "movie",
  Tv = "tv",
  Unknown = "unknown",
}

// ─── Search Response ─────────────────────────────────────────

export interface TmdbSearchResponse {
  page: number;
  results: TmdbMedia[];
  totalPages: number;
  totalResults: number;
}

export function tmdbSearchResponseFromJson(json: Record<string, unknown>): TmdbSearchResponse {
  return {
    page: json["page"] as number,
    results: (json["results"] as Record<string, unknown>[]).map(tmdbMediaFromJson),
    totalPages: json["total_pages"] as number,
    totalResults: json["total_results"] as number,
  };
}

export function tmdbSearchResponseToJson(r: TmdbSearchResponse): Record<string, unknown> {
  return {
    page: r.page,
    results: r.results.map(tmdbMediaToJson),
    total_pages: r.totalPages,
    total_results: r.totalResults,
  };
}

// ─── TmdbMedia ───────────────────────────────────────────────

export interface TmdbMedia {
  id: number;
  adult: boolean;
  mediaType: MediaType;
  genreIds: number[];
  popularity: number;
  voteAverage: number;
  voteCount: number;
  overview: string;
  backdropPath?: string;
  posterPath?: string;
  originalLanguage?: string;
  // Movie-specific
  title?: string;
  originalTitle?: string;
  releaseDate?: string;
  video?: boolean;
  // TV-specific
  name?: string;
  originalName?: string;
  firstAirDate?: string;
  originCountry?: string[];
}

export const displayTitle = (m: TmdbMedia): string => m.title ?? m.name ?? "Unknown";
export const displayDate = (m: TmdbMedia): string | undefined => m.releaseDate ?? m.firstAirDate;
export const isMovie = (m: TmdbMedia): boolean => m.mediaType === MediaType.Movie;
export const isTv = (m: TmdbMedia): boolean => m.mediaType === MediaType.Tv;
export const posterUrl = (m: TmdbMedia): string | undefined =>
  m.posterPath ? `https://image.tmdb.org/t/p/w500${m.posterPath}` : undefined;
export const backdropUrl = (m: TmdbMedia): string | undefined =>
  m.backdropPath ? `https://image.tmdb.org/t/p/w1280${m.backdropPath}` : undefined;
export const isAnime = (m: TmdbMedia): boolean =>
  m.genreIds.includes(16) && (m.originCountry?.includes("JP") ?? false);

export function tmdbMediaFromJson(json: Record<string, unknown>): TmdbMedia {
  const mediaTypeStr = (json["media_type"] as string | undefined) ?? "";
  const mediaType =
    mediaTypeStr === "movie"
      ? MediaType.Movie
      : mediaTypeStr === "tv"
      ? MediaType.Tv
      : MediaType.Unknown;

  return {
    id: (json["id"] as number | undefined) ?? 0,
    adult: (json["adult"] as boolean | undefined) ?? false,
    mediaType,
    genreIds: ((json["genre_ids"] as unknown[] | undefined) ?? []).map((e) => e as number),
    popularity: ((json["popularity"] as number | undefined) ?? 0),
    voteAverage: ((json["vote_average"] as number | undefined) ?? 0),
    voteCount: (json["vote_count"] as number | undefined) ?? 0,
    overview: (json["overview"] as string | undefined) ?? "",
    backdropPath: json["backdrop_path"] as string | undefined,
    posterPath: json["poster_path"] as string | undefined,
    originalLanguage: json["original_language"] as string | undefined,
    title: json["title"] as string | undefined,
    originalTitle: json["original_title"] as string | undefined,
    releaseDate: json["release_date"] as string | undefined,
    video: json["video"] as boolean | undefined,
    name: json["name"] as string | undefined,
    originalName: json["original_name"] as string | undefined,
    firstAirDate: json["first_air_date"] as string | undefined,
    originCountry: (json["origin_country"] as string[] | undefined),
  };
}

export function tmdbMediaToJson(m: TmdbMedia): Record<string, unknown> {
  return {
    id: m.id,
    adult: m.adult,
    media_type: m.mediaType,
    genre_ids: m.genreIds,
    popularity: m.popularity,
    vote_average: m.voteAverage,
    vote_count: m.voteCount,
    overview: m.overview,
    ...(m.backdropPath !== undefined && { backdrop_path: m.backdropPath }),
    ...(m.posterPath !== undefined && { poster_path: m.posterPath }),
    ...(m.originalLanguage !== undefined && { original_language: m.originalLanguage }),
    ...(m.title !== undefined && { title: m.title }),
    ...(m.originalTitle !== undefined && { original_title: m.originalTitle }),
    ...(m.releaseDate !== undefined && { release_date: m.releaseDate }),
    ...(m.video !== undefined && { video: m.video }),
    ...(m.name !== undefined && { name: m.name }),
    ...(m.originalName !== undefined && { original_name: m.originalName }),
    ...(m.firstAirDate !== undefined && { first_air_date: m.firstAirDate }),
    ...(m.originCountry !== undefined && { origin_country: m.originCountry }),
  };
}

// ─── BelongsToCollection ─────────────────────────────────────

export interface BelongsToCollection {
  id: number;
  name: string;
  posterPath?: string;
  backdropPath?: string;
}

export function belongsToCollectionFromJson(json: Record<string, unknown>): BelongsToCollection {
  return {
    id: json["id"] as number,
    name: (json["name"] as string | undefined) ?? "",
    posterPath: json["poster_path"] as string | undefined,
    backdropPath: json["backdrop_path"] as string | undefined,
  };
}

export function belongsToCollectionToJson(b: BelongsToCollection): Record<string, unknown> {
  return {
    id: b.id,
    name: b.name,
    ...(b.posterPath !== undefined && { poster_path: b.posterPath }),
    ...(b.backdropPath !== undefined && { backdrop_path: b.backdropPath }),
  };
}

// ─── Genre ───────────────────────────────────────────────────

export interface Genre {
  id: number;
  name: string;
}

export function genreFromJson(json: Record<string, unknown>): Genre {
  return { id: json["id"] as number, name: json["name"] as string };
}

export function genreToJson(g: Genre): Record<string, unknown> {
  return { id: g.id, name: g.name };
}

// ─── ProductionCompany ───────────────────────────────────────

export interface ProductionCompany {
  id: number;
  logoPath?: string;
  name: string;
  originCountry: string;
}

export const productionCompanyLogoUrl = (p: ProductionCompany): string | undefined =>
  p.logoPath ? `https://image.tmdb.org/t/p/w200${p.logoPath}` : undefined;

export function productionCompanyFromJson(json: Record<string, unknown>): ProductionCompany {
  return {
    id: json["id"] as number,
    logoPath: json["logo_path"] as string | undefined,
    name: (json["name"] as string | undefined) ?? "",
    originCountry: (json["origin_country"] as string | undefined) ?? "",
  };
}

export function productionCompanyToJson(p: ProductionCompany): Record<string, unknown> {
  return {
    id: p.id,
    name: p.name,
    origin_country: p.originCountry,
    ...(p.logoPath !== undefined && { logo_path: p.logoPath }),
  };
}

// ─── ProductionCountry ───────────────────────────────────────

export interface ProductionCountry {
  iso31661: string;
  name: string;
}

export function productionCountryFromJson(json: Record<string, unknown>): ProductionCountry {
  return {
    iso31661: (json["iso_3166_1"] as string | undefined) ?? "",
    name: (json["name"] as string | undefined) ?? "",
  };
}

export function productionCountryToJson(p: ProductionCountry): Record<string, unknown> {
  return { iso_3166_1: p.iso31661, name: p.name };
}

// ─── SpokenLanguage ──────────────────────────────────────────

export interface SpokenLanguage {
  englishName: string;
  iso6391: string;
  name: string;
}

export function spokenLanguageFromJson(json: Record<string, unknown>): SpokenLanguage {
  return {
    englishName: (json["english_name"] as string | undefined) ?? "",
    iso6391: (json["iso_639_1"] as string | undefined) ?? "",
    name: (json["name"] as string | undefined) ?? "",
  };
}

export function spokenLanguageToJson(s: SpokenLanguage): Record<string, unknown> {
  return { english_name: s.englishName, iso_639_1: s.iso6391, name: s.name };
}

// ─── Episode ─────────────────────────────────────────────────

export interface Episode {
  id: number;
  name: string;
  overview: string;
  voteAverage: number;
  voteCount: number;
  airDate: string;
  episodeNumber: number;
  productionCode: string;
  runtime?: number;
  seasonNumber: number;
  showId: number;
  stillPath?: string;
}

export const episodeStillUrl = (e: Episode): string | undefined =>
  e.stillPath ? `https://image.tmdb.org/t/p/w300${e.stillPath}` : undefined;

export function episodeFromJson(json: Record<string, unknown>): Episode {
  return {
    id: json["id"] as number,
    name: (json["name"] as string | undefined) ?? "",
    overview: (json["overview"] as string | undefined) ?? "",
    voteAverage: ((json["vote_average"] as number | undefined) ?? 0),
    voteCount: (json["vote_count"] as number | undefined) ?? 0,
    airDate: (json["air_date"] as string | undefined) ?? "",
    episodeNumber: (json["episode_number"] as number | undefined) ?? 0,
    productionCode: (json["production_code"] as string | undefined) ?? "",
    runtime: json["runtime"] as number | undefined,
    seasonNumber: (json["season_number"] as number | undefined) ?? 0,
    showId: (json["show_id"] as number | undefined) ?? 0,
    stillPath: json["still_path"] as string | undefined,
  };
}

export function episodeToJson(e: Episode): Record<string, unknown> {
  return {
    id: e.id,
    name: e.name,
    overview: e.overview,
    vote_average: e.voteAverage,
    vote_count: e.voteCount,
    air_date: e.airDate,
    episode_number: e.episodeNumber,
    production_code: e.productionCode,
    season_number: e.seasonNumber,
    show_id: e.showId,
    ...(e.runtime !== undefined && { runtime: e.runtime }),
    ...(e.stillPath !== undefined && { still_path: e.stillPath }),
  };
}

// ─── Network ─────────────────────────────────────────────────

export interface Network {
  id: number;
  logoPath?: string;
  name: string;
  originCountry: string;
}

export const networkLogoUrl = (n: Network): string | undefined =>
  n.logoPath ? `https://image.tmdb.org/t/p/w200${n.logoPath}` : undefined;

export function networkFromJson(json: Record<string, unknown>): Network {
  return {
    id: json["id"] as number,
    logoPath: json["logo_path"] as string | undefined,
    name: (json["name"] as string | undefined) ?? "",
    originCountry: (json["origin_country"] as string | undefined) ?? "",
  };
}

export function networkToJson(n: Network): Record<string, unknown> {
  return {
    id: n.id,
    name: n.name,
    origin_country: n.originCountry,
    ...(n.logoPath !== undefined && { logo_path: n.logoPath }),
  };
}

// ─── Season ──────────────────────────────────────────────────

export interface Season {
  airDate?: string;
  episodeCount: number;
  id: number;
  name: string;
  overview: string;
  posterPath?: string;
  seasonNumber: number;
  voteAverage: number;
}

export const seasonPosterUrl = (s: Season): string | undefined =>
  s.posterPath ? `https://image.tmdb.org/t/p/w300${s.posterPath}` : undefined;
export const isSpecials = (s: Season): boolean => s.seasonNumber === 0;

export function seasonFromJson(json: Record<string, unknown>): Season {
  return {
    airDate: json["air_date"] as string | undefined,
    episodeCount: (json["episode_count"] as number | undefined) ?? 0,
    id: (json["id"] as number | undefined) ?? 0,
    name: (json["name"] as string | undefined) ?? "",
    overview: (json["overview"] as string | undefined) ?? "",
    posterPath: json["poster_path"] as string | undefined,
    seasonNumber: (json["season_number"] as number | undefined) ?? 0,
    voteAverage: ((json["vote_average"] as number | undefined) ?? 0),
  };
}

export function seasonToJson(s: Season): Record<string, unknown> {
  return {
    episode_count: s.episodeCount,
    id: s.id,
    name: s.name,
    overview: s.overview,
    season_number: s.seasonNumber,
    vote_average: s.voteAverage,
    ...(s.airDate !== undefined && { air_date: s.airDate }),
    ...(s.posterPath !== undefined && { poster_path: s.posterPath }),
  };
}

// ─── SeasonDetail ────────────────────────────────────────────

export interface SeasonDetail {
  internalId: string;
  airDate?: string;
  episodes: Episode[];
  name: string;
  overview: string;
  id: number;
  posterPath?: string;
  seasonNumber: number;
  voteAverage: number;
}

export function seasonDetailFromJson(json: Record<string, unknown>): SeasonDetail {
  return {
    internalId: (json["_id"] as string | undefined) ?? "",
    airDate: json["air_date"] as string | undefined,
    episodes: ((json["episodes"] as Record<string, unknown>[] | undefined) ?? []).map(
      episodeFromJson,
    ),
    name: (json["name"] as string | undefined) ?? "",
    overview: (json["overview"] as string | undefined) ?? "",
    id: (json["id"] as number | undefined) ?? 0,
    posterPath: json["poster_path"] as string | undefined,
    seasonNumber: (json["season_number"] as number | undefined) ?? 0,
    voteAverage: ((json["vote_average"] as number | undefined) ?? 0),
  };
}

// ─── Credits ─────────────────────────────────────────────────

export interface CreditResponse {
  id: number;
  cast: Cast[];
  crew: Crew[];
}

export function creditResponseFromJson(json: Record<string, unknown>): CreditResponse {
  return {
    id: json["id"] as number,
    cast: ((json["cast"] as Record<string, unknown>[] | undefined) ?? []).map(castFromJson),
    crew: ((json["crew"] as Record<string, unknown>[] | undefined) ?? []).map(crewFromJson),
  };
}

export interface Cast {
  id: number;
  name: string;
  originalName: string;
  character: string;
  profilePath?: string;
  order: number;
}

export const castProfileUrl = (c: Cast): string | undefined =>
  c.profilePath ? `https://image.tmdb.org/t/p/w185${c.profilePath}` : undefined;

export function castFromJson(json: Record<string, unknown>): Cast {
  return {
    id: json["id"] as number,
    name: (json["name"] as string | undefined) ?? "",
    originalName: (json["original_name"] as string | undefined) ?? "",
    character: (json["character"] as string | undefined) ?? "",
    profilePath: json["profile_path"] as string | undefined,
    order: (json["order"] as number | undefined) ?? 0,
  };
}

export interface Crew {
  id: number;
  name: string;
  department: string;
  job: string;
  profilePath?: string;
}

export const crewProfileUrl = (c: Crew): string | undefined =>
  c.profilePath ? `https://image.tmdb.org/t/p/w185${c.profilePath}` : undefined;

export function crewFromJson(json: Record<string, unknown>): Crew {
  return {
    id: json["id"] as number,
    name: (json["name"] as string | undefined) ?? "",
    department: (json["department"] as string | undefined) ?? "",
    job: (json["job"] as string | undefined) ?? "",
    profilePath: json["profile_path"] as string | undefined,
  };
}

// ─── AlternativeTitle ────────────────────────────────────────

export interface AlternativeTitle {
  title: string;
  type?: string;
}

export function alternativeTitleFromJson(json: Record<string, unknown>): AlternativeTitle {
  return {
    title: ((json["title"] ?? json["name"]) as string | undefined) ?? "",
    type: json["type"] as string | undefined,
  };
}

// ─── ReleaseInfo / ReleaseDate ────────────────────────────────

export interface ReleaseDate {
  releaseDate: string;
  certification?: string;
  type: number;
}

export function releaseDateFromJson(json: Record<string, unknown>): ReleaseDate {
  return {
    releaseDate: (json["release_date"] as string | undefined) ?? "",
    certification: json["certification"] as string | undefined,
    type: (json["type"] as number | undefined) ?? 0,
  };
}

export interface ReleaseInfo {
  iso31661?: string;
  releaseDates?: ReleaseDate[];
  rating?: string;
}

export function releaseInfoFromJson(json: Record<string, unknown>): ReleaseInfo {
  return {
    iso31661: json["iso_3166_1"] as string | undefined,
    rating: json["rating"] as string | undefined,
    releaseDates: (json["release_dates"] as Record<string, unknown>[] | undefined)?.map(
      releaseDateFromJson,
    ),
  };
}

// ─── Movie ───────────────────────────────────────────────────

export interface Movie {
  adult: boolean;
  backdropPath?: string;
  genreIds: number[];
  id: number;
  originalLanguage: string;
  originalTitle: string;
  overview: string;
  popularity: number;
  posterPath?: string;
  releaseDate: string;
  title: string;
  video: boolean;
  voteAverage: number;
  voteCount: number;
}

export const moviePosterUrl = (m: Movie): string | undefined =>
  m.posterPath ? `https://image.tmdb.org/t/p/w500${m.posterPath}` : undefined;
export const movieBackdropUrl = (m: Movie): string | undefined =>
  m.backdropPath ? `https://image.tmdb.org/t/p/original${m.backdropPath}` : undefined;
export const movieYear = (m: Movie): string =>
  m.releaseDate.length > 0 ? m.releaseDate.substring(0, 4) : "N/A";

export function movieFromJson(json: Record<string, unknown>): Movie {
  return {
    adult: json["adult"] as boolean,
    backdropPath: json["backdrop_path"] as string | undefined,
    genreIds: (json["genre_ids"] as number[]),
    id: json["id"] as number,
    originalLanguage: json["original_language"] as string,
    originalTitle: json["original_title"] as string,
    overview: json["overview"] as string,
    popularity: json["popularity"] as number,
    posterPath: json["poster_path"] as string | undefined,
    releaseDate: (json["release_date"] as string | undefined) ?? "",
    title: json["title"] as string,
    video: json["video"] as boolean,
    voteAverage: json["vote_average"] as number,
    voteCount: json["vote_count"] as number,
  };
}

export function movieToJson(m: Movie): Record<string, unknown> {
  return {
    adult: m.adult,
    genre_ids: m.genreIds,
    id: m.id,
    original_language: m.originalLanguage,
    original_title: m.originalTitle,
    overview: m.overview,
    popularity: m.popularity,
    release_date: m.releaseDate,
    title: m.title,
    video: m.video,
    vote_average: m.voteAverage,
    vote_count: m.voteCount,
    ...(m.backdropPath !== undefined && { backdrop_path: m.backdropPath }),
    ...(m.posterPath !== undefined && { poster_path: m.posterPath }),
  };
}

export interface PopularMoviesResponse {
  page: number;
  results: Movie[];
  totalPages: number;
  totalResults: number;
}

export function popularMoviesResponseFromJson(
  json: Record<string, unknown>,
): PopularMoviesResponse {
  return {
    page: json["page"] as number,
    results: (json["results"] as Record<string, unknown>[]).map(movieFromJson),
    totalPages: json["total_pages"] as number,
    totalResults: json["total_results"] as number,
  };
}

// ─── MovieDetail ─────────────────────────────────────────────

export interface MovieDetail {
  adult: boolean;
  backdropPath?: string;
  belongsToCollection?: BelongsToCollection;
  budget: number;
  genres: Genre[];
  homepage?: string;
  id: number;
  imdbId?: string;
  originalLanguage: string;
  originalTitle: string;
  overview: string;
  popularity: number;
  posterPath?: string;
  productionCompanies: ProductionCompany[];
  productionCountries: ProductionCountry[];
  releaseDate: string;
  revenue: number;
  runtime: number;
  spokenLanguages: SpokenLanguage[];
  status: string;
  tagline?: string;
  title: string;
  video: boolean;
  voteAverage: number;
  voteCount: number;
}

export const movieDetailPosterUrl = (m: MovieDetail): string | undefined =>
  m.posterPath ? `https://image.tmdb.org/t/p/w500${m.posterPath}` : undefined;
export const movieDetailBackdropUrl = (m: MovieDetail): string | undefined =>
  m.backdropPath ? `https://image.tmdb.org/t/p/original${m.backdropPath}` : undefined;
export const movieDetailYear = (m: MovieDetail): string =>
  m.releaseDate.length > 0 ? m.releaseDate.substring(0, 4) : "N/A";
export const movieDetailRuntimeFormatted = (m: MovieDetail): string => {
  const h = Math.floor(m.runtime / 60);
  const min = m.runtime % 60;
  return h > 0 ? `${h}h ${min}m` : `${min}m`;
};
export const movieDetailGenreNames = (m: MovieDetail): string[] => m.genres.map((g) => g.name);

export function movieDetailFromJson(json: Record<string, unknown>): MovieDetail {
  return {
    adult: json["adult"] as boolean,
    backdropPath: json["backdrop_path"] as string | undefined,
    belongsToCollection:
      json["belongs_to_collection"] != null
        ? belongsToCollectionFromJson(json["belongs_to_collection"] as Record<string, unknown>)
        : undefined,
    budget: json["budget"] as number,
    genres: (json["genres"] as Record<string, unknown>[]).map(genreFromJson),
    homepage: json["homepage"] as string | undefined,
    id: json["id"] as number,
    imdbId: json["imdb_id"] as string | undefined,
    originalLanguage: json["original_language"] as string,
    originalTitle: json["original_title"] as string,
    overview: json["overview"] as string,
    popularity: json["popularity"] as number,
    posterPath: json["poster_path"] as string | undefined,
    productionCompanies: (json["production_companies"] as Record<string, unknown>[]).map(
      productionCompanyFromJson,
    ),
    productionCountries: (json["production_countries"] as Record<string, unknown>[]).map(
      productionCountryFromJson,
    ),
    releaseDate: (json["release_date"] as string | undefined) ?? "",
    revenue: json["revenue"] as number,
    runtime: json["runtime"] as number,
    spokenLanguages: (json["spoken_languages"] as Record<string, unknown>[]).map(
      spokenLanguageFromJson,
    ),
    status: json["status"] as string,
    tagline: json["tagline"] as string | undefined,
    title: json["title"] as string,
    video: json["video"] as boolean,
    voteAverage: json["vote_average"] as number,
    voteCount: json["vote_count"] as number,
  };
}

// ─── TvShow ──────────────────────────────────────────────────

export interface TvShow {
  backdropPath?: string;
  firstAirDate: string;
  genreIds: number[];
  id: number;
  name: string;
  originCountry: string[];
  originalLanguage: string;
  originalName: string;
  overview: string;
  popularity: number;
  posterPath?: string;
  voteAverage: number;
  voteCount: number;
}

export const tvShowPosterUrl = (t: TvShow): string | undefined =>
  t.posterPath ? `https://image.tmdb.org/t/p/w500${t.posterPath}` : undefined;
export const tvShowBackdropUrl = (t: TvShow): string | undefined =>
  t.backdropPath ? `https://image.tmdb.org/t/p/original${t.backdropPath}` : undefined;
export const tvShowYear = (t: TvShow): string =>
  t.firstAirDate.length > 0 ? t.firstAirDate.substring(0, 4) : "N/A";

export function tvShowFromJson(json: Record<string, unknown>): TvShow {
  return {
    backdropPath: json["backdrop_path"] as string | undefined,
    firstAirDate: (json["first_air_date"] as string | undefined) ?? "",
    genreIds: (json["genre_ids"] as number[]),
    id: json["id"] as number,
    name: json["name"] as string,
    originCountry: json["origin_country"] as string[],
    originalLanguage: json["original_language"] as string,
    originalName: json["original_name"] as string,
    overview: json["overview"] as string,
    popularity: json["popularity"] as number,
    posterPath: json["poster_path"] as string | undefined,
    voteAverage: json["vote_average"] as number,
    voteCount: json["vote_count"] as number,
  };
}

export function tvShowToJson(t: TvShow): Record<string, unknown> {
  return {
    first_air_date: t.firstAirDate,
    genre_ids: t.genreIds,
    id: t.id,
    name: t.name,
    origin_country: t.originCountry,
    original_language: t.originalLanguage,
    original_name: t.originalName,
    overview: t.overview,
    popularity: t.popularity,
    vote_average: t.voteAverage,
    vote_count: t.voteCount,
    ...(t.backdropPath !== undefined && { backdrop_path: t.backdropPath }),
    ...(t.posterPath !== undefined && { poster_path: t.posterPath }),
  };
}

export interface TopRatedTvResponse {
  page: number;
  results: TvShow[];
  totalPages: number;
  totalResults: number;
}

export function topRatedTvResponseFromJson(json: Record<string, unknown>): TopRatedTvResponse {
  return {
    page: json["page"] as number,
    results: (json["results"] as Record<string, unknown>[]).map(tvShowFromJson),
    totalPages: json["total_pages"] as number,
    totalResults: json["total_results"] as number,
  };
}

// ─── CreatedBy ───────────────────────────────────────────────

export interface CreatedBy {
  id: number;
  creditId: string;
  name: string;
  gender: number;
  profilePath?: string;
}

export const createdByProfileUrl = (c: CreatedBy): string | undefined =>
  c.profilePath ? `https://image.tmdb.org/t/p/w185${c.profilePath}` : undefined;

export function createdByFromJson(json: Record<string, unknown>): CreatedBy {
  return {
    id: json["id"] as number,
    creditId: json["credit_id"] as string,
    name: json["name"] as string,
    gender: json["gender"] as number,
    profilePath: json["profile_path"] as string | undefined,
  };
}

export function createdByToJson(c: CreatedBy): Record<string, unknown> {
  return {
    id: c.id,
    credit_id: c.creditId,
    name: c.name,
    gender: c.gender,
    ...(c.profilePath !== undefined && { profile_path: c.profilePath }),
  };
}

// ─── TvShowDetail ─────────────────────────────────────────────

export interface TvShowDetail {
  adult: boolean;
  backdropPath?: string;
  createdBy: CreatedBy[];
  episodeRunTime: number[];
  firstAirDate: string;
  genres: Genre[];
  homepage?: string;
  id: number;
  inProduction: boolean;
  languages: string[];
  lastAirDate: string;
  lastEpisodeToAir?: Episode;
  name: string;
  nextEpisodeToAir?: Episode;
  networks: Network[];
  numberOfEpisodes: number;
  numberOfSeasons: number;
  originCountry: string[];
  originalLanguage: string;
  originalName: string;
  overview: string;
  popularity: number;
  posterPath?: string;
  productionCompanies: ProductionCompany[];
  productionCountries: ProductionCountry[];
  seasons: Season[];
  spokenLanguages: SpokenLanguage[];
  status: string;
  tagline?: string;
  type: string;
  voteAverage: number;
  voteCount: number;
}

export const tvShowDetailPosterUrl = (t: TvShowDetail): string | undefined =>
  t.posterPath ? `https://image.tmdb.org/t/p/w500${t.posterPath}` : undefined;
export const tvShowDetailBackdropUrl = (t: TvShowDetail): string | undefined =>
  t.backdropPath ? `https://image.tmdb.org/t/p/original${t.backdropPath}` : undefined;
export const tvShowDetailStartYear = (t: TvShowDetail): string =>
  t.firstAirDate.length > 0 ? t.firstAirDate.substring(0, 4) : "N/A";
export const tvShowDetailEndYear = (t: TvShowDetail): string =>
  t.lastAirDate.length > 0 ? t.lastAirDate.substring(0, 4) : "N/A";
export const tvShowDetailYearRange = (t: TvShowDetail): string =>
  t.inProduction
    ? `${tvShowDetailStartYear(t)}–`
    : `${tvShowDetailStartYear(t)}–${tvShowDetailEndYear(t)}`;
export const tvShowDetailGenreNames = (t: TvShowDetail): string[] => t.genres.map((g) => g.name);
export const regularSeasons = (t: TvShowDetail): Season[] =>
  t.seasons.filter((s) => s.seasonNumber > 0);

export function tvShowDetailFromJson(json: Record<string, unknown>): TvShowDetail {
  return {
    adult: json["adult"] as boolean,
    backdropPath: json["backdrop_path"] as string | undefined,
    createdBy: (json["created_by"] as Record<string, unknown>[]).map(createdByFromJson),
    episodeRunTime: (json["episode_run_time"] as number[]),
    firstAirDate: (json["first_air_date"] as string | undefined) ?? "",
    genres: (json["genres"] as Record<string, unknown>[]).map(genreFromJson),
    homepage: json["homepage"] as string | undefined,
    id: json["id"] as number,
    inProduction: json["in_production"] as boolean,
    languages: json["languages"] as string[],
    lastAirDate: (json["last_air_date"] as string | undefined) ?? "",
    lastEpisodeToAir:
      json["last_episode_to_air"] != null
        ? episodeFromJson(json["last_episode_to_air"] as Record<string, unknown>)
        : undefined,
    name: json["name"] as string,
    nextEpisodeToAir:
      json["next_episode_to_air"] != null
        ? episodeFromJson(json["next_episode_to_air"] as Record<string, unknown>)
        : undefined,
    networks: (json["networks"] as Record<string, unknown>[]).map(networkFromJson),
    numberOfEpisodes: json["number_of_episodes"] as number,
    numberOfSeasons: json["number_of_seasons"] as number,
    originCountry: json["origin_country"] as string[],
    originalLanguage: json["original_language"] as string,
    originalName: json["original_name"] as string,
    overview: json["overview"] as string,
    popularity: json["popularity"] as number,
    posterPath: json["poster_path"] as string | undefined,
    productionCompanies: (json["production_companies"] as Record<string, unknown>[]).map(
      productionCompanyFromJson,
    ),
    productionCountries: (json["production_countries"] as Record<string, unknown>[]).map(
      productionCountryFromJson,
    ),
    seasons: (json["seasons"] as Record<string, unknown>[]).map(seasonFromJson),
    spokenLanguages: (json["spoken_languages"] as Record<string, unknown>[]).map(
      spokenLanguageFromJson,
    ),
    status: json["status"] as string,
    tagline: json["tagline"] as string | undefined,
    type: json["type"] as string,
    voteAverage: json["vote_average"] as number,
    voteCount: json["vote_count"] as number,
  };
}

// ─── Person ──────────────────────────────────────────────────

export interface PersonDetails {
  adult: boolean;
  alsoKnownAs: string[];
  biography: string;
  birthday?: string;
  deathday?: string;
  gender: number;
  homepage?: string;
  id: number;
  imdbId: string;
  knownForDepartment: string;
  name: string;
  placeOfBirth: string;
  popularity: number;
  profilePath?: string;
}

export function personDetailsFromJson(json: Record<string, unknown>): PersonDetails {
  return {
    adult: (json["adult"] as boolean | undefined) ?? false,
    alsoKnownAs: (json["also_known_as"] as string[] | undefined) ?? [],
    biography: (json["biography"] as string | undefined) ?? "",
    birthday: json["birthday"] as string | undefined,
    deathday: json["deathday"] as string | undefined,
    gender: (json["gender"] as number | undefined) ?? 0,
    homepage: json["homepage"] as string | undefined,
    id: (json["id"] as number | undefined) ?? 0,
    imdbId: (json["imdb_id"] as string | undefined) ?? "",
    knownForDepartment: (json["known_for_department"] as string | undefined) ?? "",
    name: (json["name"] as string | undefined) ?? "",
    placeOfBirth: (json["place_of_birth"] as string | undefined) ?? "",
    popularity: ((json["popularity"] as number | undefined) ?? 0),
    profilePath: json["profile_path"] as string | undefined,
  };
}

export function personDetailsToJson(p: PersonDetails): Record<string, unknown> {
  return {
    adult: p.adult,
    also_known_as: p.alsoKnownAs,
    biography: p.biography,
    birthday: p.birthday,
    deathday: p.deathday,
    gender: p.gender,
    homepage: p.homepage,
    id: p.id,
    imdb_id: p.imdbId,
    known_for_department: p.knownForDepartment,
    name: p.name,
    place_of_birth: p.placeOfBirth,
    popularity: p.popularity,
    profile_path: p.profilePath,
  };
}

// ─── PersonCredits ────────────────────────────────────────────

export interface PersonCredits {
  id: number;
  cast: CastCredit[];
  crew: CrewCredit[];
}

export function personCreditsFromJson(json: Record<string, unknown>): PersonCredits {
  return {
    id: json["id"] as number,
    cast: (json["cast"] as Record<string, unknown>[]).map(castCreditFromJson),
    crew: (json["crew"] as Record<string, unknown>[]).map(crewCreditFromJson),
  };
}

export function personCreditsToJson(p: PersonCredits): Record<string, unknown> {
  return {
    id: p.id,
    cast: p.cast.map(castCreditToJson),
    crew: p.crew.map(crewCreditToJson),
  };
}

// ─── CastCredit (discriminated union) ─────────────────────────

interface BaseCreditFields {
  adult: boolean;
  backdropPath?: string;
  genreIds: number[];
  id: number;
  originalLanguage: string;
  overview?: string;
  popularity: number;
  posterPath?: string;
  voteAverage: number;
  voteCount: number;
  character: string;
  creditId: string;
  mediaType: string;
}

export interface MovieCastCredit extends BaseCreditFields {
  mediaType: "movie";
  originalTitle?: string;
  releaseDate?: string;
  title?: string;
  video: boolean;
  order: number;
}

export interface TvCastCredit extends BaseCreditFields {
  mediaType: "tv";
  originCountry: string[];
  originalName?: string;
  firstAirDate?: string;
  name?: string;
  episodeCount: number;
}

export type CastCredit = MovieCastCredit | TvCastCredit;

export function castCreditFromJson(json: Record<string, unknown>): CastCredit {
  const mediaType = (json["media_type"] as string | undefined) ?? "";
  const base: BaseCreditFields = {
    adult: (json["adult"] as boolean | undefined) ?? false,
    backdropPath: json["backdrop_path"] as string | undefined,
    genreIds: ((json["genre_ids"] as unknown[] | undefined) ?? []) as number[],
    id: (json["id"] as number | undefined) ?? 0,
    originalLanguage: (json["original_language"] as string | undefined) ?? "",
    overview: json["overview"] as string | undefined,
    popularity: ((json["popularity"] as number | undefined) ?? 0),
    posterPath: json["poster_path"] as string | undefined,
    voteAverage: ((json["vote_average"] as number | undefined) ?? 0),
    voteCount: (json["vote_count"] as number | undefined) ?? 0,
    character: (json["character"] as string | undefined) ?? "",
    creditId: (json["credit_id"] as string | undefined) ?? "",
    mediaType,
  };

  if (mediaType === "movie") {
    return {
      ...base,
      mediaType: "movie",
      originalTitle: json["original_title"] as string | undefined,
      releaseDate: json["release_date"] as string | undefined,
      title: json["title"] as string | undefined,
      video: (json["video"] as boolean | undefined) ?? false,
      order: (json["order"] as number | undefined) ?? 0,
    };
  } else {
    return {
      ...base,
      mediaType: "tv",
      originCountry: ((json["origin_country"] as string[] | undefined) ?? []),
      originalName: json["original_name"] as string | undefined,
      firstAirDate: json["first_air_date"] as string | undefined,
      name: json["name"] as string | undefined,
      episodeCount: (json["episode_count"] as number | undefined) ?? 0,
    };
  }
}

export function castCreditToJson(c: CastCredit): Record<string, unknown> {
  if (c.mediaType === "movie") {
    return {
      adult: c.adult,
      backdrop_path: c.backdropPath,
      genre_ids: c.genreIds,
      id: c.id,
      original_language: c.originalLanguage,
      overview: c.overview,
      popularity: c.popularity,
      poster_path: c.posterPath,
      vote_average: c.voteAverage,
      vote_count: c.voteCount,
      character: c.character,
      credit_id: c.creditId,
      media_type: c.mediaType,
      original_title: c.originalTitle,
      release_date: c.releaseDate,
      title: c.title,
      video: c.video,
      order: c.order,
    };
  } else {
    return {
      adult: c.adult,
      backdrop_path: c.backdropPath,
      genre_ids: c.genreIds,
      id: c.id,
      original_language: c.originalLanguage,
      overview: c.overview,
      popularity: c.popularity,
      poster_path: c.posterPath,
      vote_average: c.voteAverage,
      vote_count: c.voteCount,
      character: c.character,
      credit_id: c.creditId,
      media_type: c.mediaType,
      origin_country: c.originCountry,
      original_name: c.originalName,
      first_air_date: c.firstAirDate,
      name: c.name,
      episode_count: c.episodeCount,
    };
  }
}

// ─── CrewCredit (discriminated union) ─────────────────────────

export interface MovieCrewCredit extends BaseCreditFields {
  mediaType: "movie";
  originalTitle?: string;
  releaseDate?: string;
  title?: string;
  video: boolean;
  department: string;
  job: string;
}

export interface TvCrewCredit extends BaseCreditFields {
  mediaType: "tv";
  originCountry: string[];
  originalName?: string;
  firstAirDate?: string;
  name?: string;
  episodeCount: number;
  department: string;
  job: string;
}

export type CrewCredit = MovieCrewCredit | TvCrewCredit;

export function crewCreditFromJson(json: Record<string, unknown>): CrewCredit {
  const mediaType = (json["media_type"] as string | undefined) ?? "";
  const base: BaseCreditFields = {
    adult: (json["adult"] as boolean | undefined) ?? false,
    backdropPath: json["backdrop_path"] as string | undefined,
    genreIds: ((json["genre_ids"] as unknown[] | undefined) ?? []) as number[],
    id: (json["id"] as number | undefined) ?? 0,
    originalLanguage: (json["original_language"] as string | undefined) ?? "",
    overview: json["overview"] as string | undefined,
    popularity: ((json["popularity"] as number | undefined) ?? 0),
    posterPath: json["poster_path"] as string | undefined,
    voteAverage: ((json["vote_average"] as number | undefined) ?? 0),
    voteCount: (json["vote_count"] as number | undefined) ?? 0,
    character: "",
    creditId: (json["credit_id"] as string | undefined) ?? "",
    mediaType,
  };

  if (mediaType === "movie") {
    return {
      ...base,
      mediaType: "movie",
      originalTitle: json["original_title"] as string | undefined,
      releaseDate: json["release_date"] as string | undefined,
      title: json["title"] as string | undefined,
      video: (json["video"] as boolean | undefined) ?? false,
      department: (json["department"] as string | undefined) ?? "",
      job: (json["job"] as string | undefined) ?? "",
    };
  } else {
    return {
      ...base,
      mediaType: "tv",
      originCountry: ((json["origin_country"] as string[] | undefined) ?? []),
      originalName: json["original_name"] as string | undefined,
      firstAirDate: json["first_air_date"] as string | undefined,
      name: json["name"] as string | undefined,
      episodeCount: (json["episode_count"] as number | undefined) ?? 0,
      department: (json["department"] as string | undefined) ?? "",
      job: (json["job"] as string | undefined) ?? "",
    };
  }
}

export function crewCreditToJson(c: CrewCredit): Record<string, unknown> {
  if (c.mediaType === "movie") {
    return {
      adult: c.adult,
      backdrop_path: c.backdropPath,
      genre_ids: c.genreIds,
      id: c.id,
      original_language: c.originalLanguage,
      original_title: c.originalTitle,
      overview: c.overview,
      popularity: c.popularity,
      poster_path: c.posterPath,
      release_date: c.releaseDate,
      title: c.title,
      video: c.video,
      vote_average: c.voteAverage,
      vote_count: c.voteCount,
      credit_id: c.creditId,
      department: c.department,
      job: c.job,
      media_type: c.mediaType,
    };
  } else {
    return {
      adult: c.adult,
      backdrop_path: c.backdropPath,
      genre_ids: c.genreIds,
      id: c.id,
      origin_country: c.originCountry,
      original_language: c.originalLanguage,
      original_name: c.originalName,
      overview: c.overview,
      popularity: c.popularity,
      poster_path: c.posterPath,
      first_air_date: c.firstAirDate,
      name: c.name,
      vote_average: c.voteAverage,
      vote_count: c.voteCount,
      credit_id: c.creditId,
      department: c.department,
      episode_count: c.episodeCount,
      job: c.job,
      media_type: c.mediaType,
    };
  }
}

// ─── Misc ─────────────────────────────────────────────────────

export interface Country {
  iso31661: string;
  englishName: string;
  nativeName: string;
}

export function countryFromJson(json: Record<string, unknown>): Country {
  return {
    iso31661: json["iso_3166_1"] as string,
    englishName: json["english_name"] as string,
    nativeName: json["native_name"] as string,
  };
}

export function countryToJson(c: Country): Record<string, unknown> {
  return { iso_3166_1: c.iso31661, english_name: c.englishName, native_name: c.nativeName };
}

export interface Language {
  iso6391: string;
  englishName: string;
  name: string;
}

export const languageDisplayName = (l: Language): string =>
  l.name.length > 0 ? l.name : l.englishName;

export function languageFromJson(json: Record<string, unknown>): Language {
  return {
    iso6391: (json["iso_639_1"] as string | undefined) ?? "",
    englishName: (json["english_name"] as string | undefined) ?? "",
    name: (json["name"] as string | undefined) ?? "",
  };
}

export function languageToJson(l: Language): Record<string, unknown> {
  return { iso_639_1: l.iso6391, english_name: l.englishName, name: l.name };
}

export interface GenreListResponse {
  genres: Genre[];
}

export function genreListResponseFromJson(json: Record<string, unknown>): GenreListResponse {
  return {
    genres: (json["genres"] as Record<string, unknown>[]).map(genreFromJson),
  };
}

export interface ParentCompany {
  id: number;
  name: string;
  logoPath?: string;
}

export const parentCompanyLogoUrl = (p: ParentCompany): string | undefined =>
  p.logoPath ? `https://image.tmdb.org/t/p/w200${p.logoPath}` : undefined;

export function parentCompanyFromJson(json: Record<string, unknown>): ParentCompany {
  return {
    id: (json["id"] as number | undefined) ?? 0,
    name: (json["name"] as string | undefined) ?? "",
    logoPath: json["logo_path"] as string | undefined,
  };
}

export function parentCompanyToJson(p: ParentCompany): Record<string, unknown> {
  return {
    id: p.id,
    name: p.name,
    ...(p.logoPath !== undefined && { logo_path: p.logoPath }),
  };
}

export interface ProductionCompanyDetail {
  description: string;
  headquarters: string;
  homepage?: string;
  id: number;
  logoPath?: string;
  name: string;
  originCountry: string;
  parentCompany?: ParentCompany;
}

export const productionCompanyDetailLogoUrl = (p: ProductionCompanyDetail): string | undefined =>
  p.logoPath ? `https://image.tmdb.org/t/p/w200${p.logoPath}` : undefined;

export function productionCompanyDetailFromJson(
  json: Record<string, unknown>,
): ProductionCompanyDetail {
  return {
    description: (json["description"] as string | undefined) ?? "",
    headquarters: (json["headquarters"] as string | undefined) ?? "",
    homepage: json["homepage"] as string | undefined,
    id: (json["id"] as number | undefined) ?? 0,
    logoPath: json["logo_path"] as string | undefined,
    name: (json["name"] as string | undefined) ?? "",
    originCountry: (json["origin_country"] as string | undefined) ?? "",
    parentCompany:
      json["parent_company"] != null
        ? parentCompanyFromJson(json["parent_company"] as Record<string, unknown>)
        : undefined,
  };
}

export function productionCompanyDetailToJson(
  p: ProductionCompanyDetail,
): Record<string, unknown> {
  return {
    description: p.description,
    headquarters: p.headquarters,
    id: p.id,
    name: p.name,
    origin_country: p.originCountry,
    ...(p.homepage !== undefined && { homepage: p.homepage }),
    ...(p.logoPath !== undefined && { logo_path: p.logoPath }),
    ...(p.parentCompany !== undefined && { parent_company: parentCompanyToJson(p.parentCompany) }),
  };
}