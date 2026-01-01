ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

WORKDIR /root

RUN apt-get update && apt-get install -y bash && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
