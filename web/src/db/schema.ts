import { pgTable, serial, text, integer, jsonb, timestamp, uniqueIndex } from 'drizzle-orm/pg-core';

export const watchHistory = pgTable('watch_history', {
  id: serial('id').primaryKey(),
  userId: text('user_id').notNull(),
  mediaId: integer('media_id').notNull(),
  type: text('type').notNull(), // 'movie' or 'tv'
  title: text('title').notNull(),
  posterPath: text('poster_path'),
  backdropPath: text('backdrop_path'),
  progress: jsonb('progress'), // { watched: number, duration: number }
  lastSeasonWatched: text('last_season_watched'),
  lastEpisodeWatched: text('last_episode_watched'),
  showProgress: jsonb('show_progress'), // Detailed episode progress
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
}, (table) => {
  return [
    uniqueIndex('user_media_idx').on(table.userId, table.mediaId),
  ]
});

export const watchList = pgTable('watch_list', {
  id: serial('id').primaryKey(),
  userId: text('user_id').notNull(),
  mediaId: integer('media_id').notNull(),
  type: text('type').notNull(), // 'movie' or 'tv'
  title: text('title').notNull(),
  posterPath: text('poster_path'),
  backdropPath: text('backdrop_path'),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
}, (table) => {
  return [
    uniqueIndex('user_media_watchlist_idx').on(table.userId, table.mediaId),
  ]
});
