## Tech Stack
- `golang` for main api service
- `drizzle` for generating schema & migrations
- `bun` for testing
- `minio` for document storage (interchangable with S3)
- `docker` for development, testing, and deployment


## Commands
There is a `Makefile` supplied with the following commands

- `make clean-build` builds the required containers for db, minio, testing, and running
- `make infrastructure` launches the db & minio containers in background
- `make test` will run the testing suite (go unit tests & bun end-to-end tests)
- `make run` will run the api service
- `make stop` will stop containers