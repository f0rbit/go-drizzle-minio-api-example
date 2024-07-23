all: 

clean-build: stop
	docker-compose --env-file .env build test-db db minio
	docker-compose --env-file .env build app --no-cache
	docker-compose --env-file .env build test --no-cache

build: stop
	docker-compose --env-file .env build test-db db minio
	docker-compose --env-file .env build app

infrastructure:
	docker-compose --env-file .env up db minio -d

stop:
	docker-compose down
	docker-compose down --remove-orphans

run: stop build infrastructure
	docker-compose --env-file .env up app

test: stop
	docker-compose --env-file .env.test build test-db minio
	docker-compose --env-file .env.test up test-db minio -d
	docker-compose --env-file .env.test build test
	docker-compose --env-file .env.test run test