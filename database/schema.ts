import { sql } from 'drizzle-orm';
import { pgTable, text, timestamp, uuid } from 'drizzle-orm/pg-core';

export const user = pgTable('user', {
	id: uuid('id').primaryKey(),
	email: text('email'),
	created_at: timestamp('created_at').default(sql`now()`),
	updated_at: timestamp('updated_at').default(sql`now()`)
});