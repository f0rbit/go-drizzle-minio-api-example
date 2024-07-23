### database
this folder contains the schema declaration file for the database. decided to use drizzle orm in order to have verison history of schema changes & a nice way to handle migrations.

### commands
- `bun reset` resets the migrations tracking
- `bun generate` generates sql documents for migrations
- `bun migrate` applies the migrations to the database
- `bun migrate:test` applies migrations to the test database

### todo
currently you have to change the DATABASE_URL to point to `127.0.0.1` instead of the database service name, since this script isn't run within the docker context. either need some way of hotswapping this into the database url or running the migration within the docker scripts.