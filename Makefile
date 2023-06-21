postgres:
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15.3-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

start-postgres:
	docker start postgres15

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock



#  docker run --rm -v "C:\Users\abhis\OneDrive\Desktop\Xerxia\simplebank:/src" -w /src kjconroy/sqlc init
#  docker run --rm -v "C:\Users\abhis\OneDrive\Desktop\Xerxia\simplebank:/src" -w /src kjconroy/sqlc generate
