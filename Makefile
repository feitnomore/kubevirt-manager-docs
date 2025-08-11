# Default Target
.PHONY: all
all : kubevirt-manager-docs

# Build the Binary
.PHONY: kubevirt-manager-docs
kubevirt-manager-docs: clean
	docker run --rm -v .:/docs kubevirtmanager/mkdocs-builder mkdocs build

.PHONY: mkdocs-builder
mkdocs-builder:
	docker build -t kubevirtmanager/mkdocs-builder:latest .
	docker push kubevirtmanager/mkdocs-builder:latest

.PHONY: clean
clean:
	sudo rm -rf site/

.PHONY: serve
serve:
	cd site/ && python3 -m http.server && cd ../