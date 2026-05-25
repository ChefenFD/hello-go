.PHONY: help run build test lint fmt clean

# Standard: vis hjælp
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

run: ## Kør programmet
	go run ./...

build: ## Byg binær
	go build -ldflags="-s -w" -o bin/$(shell basename $(CURDIR)) ./...

test: ## Kør alle tests
	gotestsum --format=testdox ./...

test-race: ## Kør tests med race detector
	go test -race ./...

lint: ## Kør linter
	golangci-lint run ./...

fmt: ## Formater kode
	gofumpt -l -w .
	goimports -l -w .

coverage: ## Vis test coverage
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

clean: ## Ryd op
	rm -rf bin/ coverage.out

tidy: ## Ryd op i go.mod
	go mod tidy

vuln: ## Tjek for kendte sårbarheder
	govulncheck ./...
