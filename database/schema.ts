import { sql } from 'drizzle-orm';
import { pgTable, text, timestamp, uuid, jsonb, integer, boolean, pgEnum } from 'drizzle-orm/pg-core';

export const stage_type = pgEnum('stage_type', ["poll", "parse", "summary"]);
export const stage_status = pgEnum('stage_status', ["queue", "started", "in_progress", "error", "finished"])
export const storage_system = pgEnum("storage_system", ["github", "aws", "sftp", "minio"]);

export const reports = pgTable('report', {
	id: uuid('id').primaryKey(),
	type: uuid('type').references(() => report_types.id),
	date: timestamp('date'),
	createdAt: timestamp('created_at').default(sql`now()`),
	updatedAt: timestamp('updated_at').default(sql`now()`),
	revision: integer('revision'),
	finished: boolean('finished'),
	outputJson: jsonb('output_json')
});

export const report_types = pgTable('report_type', {
	id: uuid('id').primaryKey(),
	pollerUrl: text('poller_url'),
	parsingUrl: text('parsing_url'),
	summaryUrl: text('summary_url'),
	description: text('description')
});

export const stages = pgTable('stages', {
	id: uuid('id').primaryKey(),
	reportId: uuid('report_id').references(() => reports.id),
	type: stage_type('type'),
	scriptName: text('script_name'),
	scriptVersion: text('script_version'),
	status: stage_status('status'),
	datetime: timestamp('datetime').default(sql`now()`),
	message: text('message')
});

export const documentLinks = pgTable('document_links', {
	id: uuid('id').primaryKey(),
	date: timestamp('date'),
	type: uuid('type').references(() => report_types.id),
	version: text('version'),
	stage: stage_type("stage"),
	storage: storage_system("storage"),
	data: jsonb('data'),
	revision: integer('revision')
});