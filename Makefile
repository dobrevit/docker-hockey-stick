.PHONY := build run

build:
	docker build -t haproxy-hockey-stick .

run:
	docker run --rm -it --name haproxy-hockey-stick \
		-p 80:80 \
		-v $(PWD)/haproxy.cfg:/etc/haproxy/haproxy.cfg \
		haproxy-hockey-stick
