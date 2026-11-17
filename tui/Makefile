.PHONY: assets build run test
assets: ; ./sync_assets.sh
build: assets ; go build -o bin/ridge ./cmd/ridge
run: assets ; go run ./cmd/ridge
test: assets ; go test ./...
