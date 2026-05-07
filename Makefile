# Task 1(d) - Automation Targets 

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

test:
	curl http://localhost:8000/health

clean:
	docker compose down -v
	docker system prune -af

shell:
	docker compose exec app bash