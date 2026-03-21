CREATE TABLE "watch_history" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"media_id" integer NOT NULL,
	"type" text NOT NULL,
	"title" text NOT NULL,
	"poster_path" text,
	"backdrop_path" text,
	"progress" jsonb,
	"last_season_watched" text,
	"last_episode_watched" text,
	"show_progress" jsonb,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX "user_media_idx" ON "watch_history" USING btree ("user_id","media_id");