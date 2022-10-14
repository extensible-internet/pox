.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<
## build_docker : builds docker image and tags dev_pox
build_docker:
	docker build . -t dev_pox -f Dockerfile-local
## run : builds docker image and tags dev_pox
run:
	docker run -d --name dev_pox -v $(PWD):/home/groove/pox/ -it dev_pox:latest /bin/bash 
## all_tests: Runs a clean test with build_all.sh 
all_tests:
	docker exec dev_pox bash scripts/build_all.sh --install --with-tests --clean --parallel
## two_clients_test: runs the basic 2 client test
two_clients_test:
	docker exec dev_pox bash tests/2node/run.sh --enable einr
## delete: Cleans up old docker dev_pox tags
delete:
	docker stop dev_pox
	docker rm dev_pox
