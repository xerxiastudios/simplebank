postgres:
	docker run --name postgres15 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15.3-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

start-postgres:
	docker start postgres15

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock



#  docker run --rm -v "C:\Users\abhis\OneDrive\Desktop\Xerxia\simplebank:/src" -w /src kjconroy/sqlc init
#  docker run --rm -v "C:\Users\abhis\OneDrive\Desktop\Xerxia\simplebank:/src" -w /src kjconroy/sqlc generate
#  docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release -e "DB_SOURCE=postgresql://root:secret@postgres15:5432/simple_bank?sslmode=disable" simplebank:latest