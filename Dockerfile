# -*- coding: utf-8 -*-

# This Dockerfile can be used to reproduce the GitHub Actions Ubuntu
# build from any machine (even Windows) that can build Docker images.

FROM ubuntu
WORKDIR /home
RUN apt update \
 && apt install -y \
   build-essential \
   cmake \
   python3-dev
COPY CMakeLists.txt .
COPY main.cpp .
RUN mkdir build \
 && cd build \
 && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release .. \
 && cmake --build . \
 && ctest
CMD "sh"
