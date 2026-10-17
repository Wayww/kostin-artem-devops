.PHONY: check test build up down logs clean

check:
	python3 app/main.py --check

test:
	python3 -m unittest discover -s tests -v

build:
	docker build -t kostin-artem-devops:latest .

up:
	docker compose up --build -d

down:
	docker compose down

logs:
	docker logs kostin-artem-container

clean:
	docker rm -f kostin-artem-container 2>/dev/null || true
