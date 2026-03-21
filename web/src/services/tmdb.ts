const BASE_URL = "/api";

const fetchWithAuth = async (path: string, token: string, params: Record<string, string> = {}) => {
  const query = new URLSearchParams(params).toString();
  const url = `${BASE_URL}/${path}${query ? `?${query}` : ''}`;
  
  const res = await fetch(url, {
    headers: {
      'Authorization': `Bearer ${token}`,
      'Accept': 'application/json'
    }
  });
  
  if (!res.ok) {
    const error = await res.json().catch(() => ({}));
    throw new Error(error.error || 'API Request failed');
  }
  
  return res.json();
};

export const fetchTrending = async (token: string) => {
  return fetchWithAuth("trending/all/week", token);
};

export const fetchPopularMovies = async (token: string, page: number = 1) => {
  // Flutter uses top_rated for popular content in some views
  return fetchWithAuth("movie/top_rated", token, { page: page.toString() });
};

export const fetchPopularShows = async (token: string, page: number = 1) => {
  return fetchWithAuth("tv/popular", token, { page: page.toString() });
};

export const fetchTopRatedMovies = async (token: string) => {
  return fetchWithAuth("movie/top_rated", token);
};

export const fetchTopRatedShows = async (token: string) => {
  return fetchWithAuth("tv/top_rated", token);
};

export const searchContent = async (query: string, token: string) => {
  return fetchWithAuth("search/multi", token, { query });
};

export const fetchMovieDetails = async (id: string, token: string) => {
  return fetchWithAuth(`movie/${id}`, token, { append_to_response: 'credits,recommendations,reviews' });
};

export const fetchShowDetails = async (id: string, token: string) => {
  return fetchWithAuth(`tv/${id}`, token, { append_to_response: 'credits,recommendations,reviews' });
};

export const fetchPersonDetails = async (id: string, token: string) => {
  return fetchWithAuth(`person/${id}`, token, { append_to_response: 'combined_credits' });
};

export const fetchGenreDetails = async (id: string, type: string, token: string) => {
  return fetchWithAuth(`discover/${type}`, token, { with_genres: id, sort_by: 'popularity.desc' });
};

export const fetchStudioDetails = async (id: string, type: string, token: string) => {
  return fetchWithAuth(`discover/${type}`, token, { with_companies: id, sort_by: 'popularity.desc' });
};

export const fetchSeasonDetails = async (id: string, seasonNumber: number, token: string) => {
  return fetchWithAuth(`tv/${id}/season/${seasonNumber}`, token);
};