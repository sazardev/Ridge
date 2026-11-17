PREFIX ?= $(HOME)/.local

.PHONY: assets build run test install matrix
assets: ; ./sync_assets.sh
build: assets ; go build -o bin/ridge ./cmd/ridge
run: assets ; go run ./cmd/ridge
test: assets ; go test ./...
matrix: build ; bash tool/terminal-matrix.sh bin/ridge
install: build ; mkdir -p $(PREFIX)/bin && install -m 755 bin/ridge $(PREFIX)/bin/ridge
