export const imageUrlBuilder = (path: string | null) => {
  if (!path) return "/assets/images/banner.png";
  return `https://image.tmdb.org/t/p/w500${path}`;
};
