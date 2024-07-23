import { defineConfig } from "drizzle-kit";

export default defineConfig({
	dialect: "postgresql",
	schema: "./schema.ts",
	out: "./drizzle",
	dbCredentials: {
		url: "postgres://user:password@0.0.0.0:5432/dbname"
	}
});