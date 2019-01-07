# see https://shecan.ir/
SHECAN_DNS = 178.22.122.100

build-docker:
    docker build . -t imgmaker
    
build-image: build-docker
    docker run -d --dns $(SHECAN_DNS) --privileged=true -v $$(pwd):/root/img imgmaker
