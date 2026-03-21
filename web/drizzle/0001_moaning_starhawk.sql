CREATE TABLE "watch_list" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"media_id" integer NOT NULL,
	"type" text NOT NULL,
	"title" text NOT NULL,
	"poster_path" text,
	"backdrop_path" text,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX "user_media_watchlist_idx" ON "watch_list" USING btree ("user_id","media_id");