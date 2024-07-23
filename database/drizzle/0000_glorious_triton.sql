DO $$ BEGIN
 CREATE TYPE "public"."stage_status" AS ENUM('queue', 'started', 'in_progress', 'error', 'finished');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "public"."stage_type" AS ENUM('poll', 'parse', 'summary');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "public"."storage_system" AS ENUM('github', 'aws', 'sftp', 'minio');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "document_links" (
	"id" uuid PRIMARY KEY NOT NULL,
	"date" timestamp,
	"type" uuid,
	"version" text,
	"stage" "stage_type",
	"storage" "storage_system",
	"data" jsonb,
	"revision" integer
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "report_type" (
	"id" uuid PRIMARY KEY NOT NULL,
	"poller_url" text,
	"parsing_url" text,
	"summary_url" text,
	"description" text
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "report" (
	"id" uuid PRIMARY KEY NOT NULL,
	"type" uuid,
	"date" timestamp,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	"revision" integer,
	"finished" boolean,
	"output_json" jsonb
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "stages" (
	"id" uuid PRIMARY KEY NOT NULL,
	"report_id" uuid,
	"type" "stage_type",
	"script_name" text,
	"script_version" text,
	"status" "stage_status",
	"datetime" timestamp DEFAULT now(),
	"message" text
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "document_links" ADD CONSTRAINT "document_links_type_report_type_id_fk" FOREIGN KEY ("type") REFERENCES "public"."report_type"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "report" ADD CONSTRAINT "report_type_report_type_id_fk" FOREIGN KEY ("type") REFERENCES "public"."report_type"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "stages" ADD CONSTRAINT "stages_report_id_report_id_fk" FOREIGN KEY ("report_id") REFERENCES "public"."report"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
