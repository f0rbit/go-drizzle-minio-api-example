import { drizzle } from 'drizzle-orm/postgres-js';
import { migrate } from "drizzle-orm/postgres-js/migrator";
import postgres from 'postgres';
import * as schema from "./schema";


const client = postgres("postgres://user:password@0.0.0.0:5432/dbname", { max: 1 });
migrate(drizzle(client, { schema }), { migrationsFolder: "./drizzle" });