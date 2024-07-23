### database
this folder contains the schema declaration file for the database. decided to use drizzle orm in order to have verison history of schema changes & a nice way to handle migrations.

### commands
- `bun reset` resets the migrations tracking
- `bun generate` generates sql documents for migrations
- `bun migrate` applies the migrations to the database
- `bun migrate:test` applies migrations to the test database

### todo
this project needs to be .env-ified, for now just uses standard user:password combinations