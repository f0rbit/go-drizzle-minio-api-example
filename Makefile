all: 

clean-build:
	docker-compose --env-file .env build db minio
	docker-compose --env-file .env build app --no-cache
	docker-compose --env-file .env build test --no-cache

run:
	docker compose --env-file .env up server

test:
	docker-compose --env-file .env.test build db minio
	docker-compose --env-file .env.test build test
	docker-compose --env-file .env.test run test