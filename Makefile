current_dir := ${CURDIR}

# Variables
INCUS_VERSION=6.3.0
IMAGE_BUILD_NAME=test/incus-build:multi
PLATFORM="linux/amd64,linux/arm64"

test:
	echo $(current_dir)

build:
	mkdir -p $(current_dir)/build
	docker build --builder multi-arch --build-arg INCUS_VERSION=$(INCUS_VERSION) --platform $(PLATFORM) --output type=local,dest=$(current_dir)/build  $(current_dir)/base

# build-multi:
# 	podman build --build-arg INCUS_VERSION=$(INCUS_VERSION) --platform "linux/amd64,linux/arm64" -t temp/incus-temp $(current_dir)/base
# 	podman build --build-arg INCUS_VERSION=$(INCUS_VERSION) --platform "linux/amd64,linux/arm64" -t $(IMAGE_BUILD_NAME) $(current_dir)/base/multi
# 	mkdir -p $(current_dir)/build
# 	podman image inspect $(IMAGE_BUILD_NAME) >> $(current_dir)/build/image.json
# 	podman rmi -f temp/incus-temp

clean:
	rm -rf $(current_dir)/build