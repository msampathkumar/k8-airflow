IMAGE_VERSION=0.2842

version:
	@echo "Image Version "${IMAGE_VERSION}

build:
	docker build --rm -t sampathm/docker-airflow .

run:
	# docker run --name airflow -p 8080:8080 sampathm/docker-airflow
	docker run -d \
	--name airflow \
	-p 5555:5555 \
	-p 8080:8080 \
	-e LOAD_EX=n \
	sampathm/docker-airflow

rm:
	docker rm -f airflow
