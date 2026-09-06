.PHONY: init config

init:
	docker run --rm --network none --cap-drop ALL --cpus 0.25 --memory 128m --user "$(shell id -u 2>/dev/null || echo 1000):$(shell id -g 2>/dev/null || echo 1000)" -v "$(CURDIR):/workspace" -w /workspace python:3.13.7-alpine3.22 python setup.py

config:
	docker compose config -q
