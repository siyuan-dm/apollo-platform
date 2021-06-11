FROM ubuntu:18.04

# To avoid tzdata asking for geographic location...
ENV DEBIAN_FRONTEND noninteractive
ARG DEBIAN_FRONTEND=noninteractive

# Set the working directory to /root
ENV DIRPATH /root
WORKDIR $DIRPATH

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
	wget curl vim git

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
	libprotobuf-dev protobuf-compiler \
	libconsole-bridge-dev \
	python3-pip libboost-all-dev \
	libpoco-doc libpoco-dev \
	python3-sip-dev libtinyxml-dev \
	liblz4-dev libbz2-dev

RUN pip3 install empy catkin_pkg nose

RUN git clone https://github.com/opencv/opencv.git
RUN cd opencv && \
      git checkout tags/3.3.1 && \
      mkdir build

RUN git clone https://github.com/opencv/opencv_contrib.git
RUN cd opencv_contrib && \
      git checkout tags/3.3.1

RUN cd opencv/build && \
      cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -D BUILD_opencv_python=ON \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=ON \
      -DOPENCV_EXTRA_MODULES_PATH=$DIRPATH/opencv_contrib/modules .. && \
      make -j$(($(nproc)-1)) && make install
RUN rm -rf opencv opencv_contrib

RUN git clone
