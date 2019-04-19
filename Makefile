build:
	docker build -t acestream-debian .

test:
	docker run --rm --name acestream -p 6878:6878 -it acestream-debian

shell:
	docker exec -it acestream bash
