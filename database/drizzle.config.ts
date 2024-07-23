import { defineConfig } from "drizzle-kit";

if (!process.env.DATABASE_URL) throw new Error("DATABASE_URL is not set");

console.log(process.env.DATABASE_URL);

export default defineConfig({
	dialect: "postgresql",
	schema: "./schema.ts",
	out: "./drizzle",
	dbCredentials: {
		url: process.env.DATABASE_URL
	}
});