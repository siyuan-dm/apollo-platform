FROM ubuntu:18.04

# To avoid tzdata asking for geographic location...
ENV DEBIAN_FRONTEND noninteractive
ARG DEBIAN_FRONTEND=noninteractive

# Set the working directory to /root
ENV DIRPATH /root
WORKDIR $DIRPATH

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
	wget curl vim git cmake build-essential

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
	libprotobuf-dev protobuf-compiler \
	libconsole-bridge-dev \
	python3-pip libboost-all-dev \
	libpoco-doc libpoco-dev \
	python3-sip-dev libtinyxml-dev \
	liblz4-dev libbz2-dev
RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
      libgtest-dev libyaml-cpp-dev uuid-dev
RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
      libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools
RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
      libpcl-dev

# Necessary python pkgs for building ros
RUN pip3 install empy catkin_pkg nose numpy rospkg protobuf netifaces

# Install OpenCV
RUN git clone https://github.com/opencv/opencv.git
RUN cd opencv && \
      git checkout tags/3.4.14 && \
      mkdir build
RUN git clone https://github.com/opencv/opencv_contrib.git
RUN cd opencv_contrib && \
      git checkout tags/3.4.14
RUN cd opencv/build && \
      cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -D BUILD_opencv_python=ON \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=ON \
      -DCMAKE_USE_OPENSSL=ON -DCMAKE_BOOTSTRAP=1 \
      -DOPENCV_EXTRA_MODULES_PATH=$DIRPATH/opencv_contrib/modules .. && \
      make -j$(($(nproc)-1)) && make install
RUN rm -rf opencv opencv_contrib

# Install gtest library
RUN cd /usr/src/gtest && cmake CMakeLists.txt && make -j$(($(nproc)-1)) && cp *.a /usr/lib

# Install apollo ros third_party 
RUN git clone https://github.com/siyuan-dm/apollo-platform.git
RUN cd apollo-platform/ros && ./build.sh clean
RUN rm -rf apollo-platform/ros/third_party/fast-rtps
RUN cd apollo-platform/ros/third_party && ./build.sh build

# Install apollo ros env
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN cd apollo-platform/ros && ./build.sh build
RUN cd apollo-platform/ros/third_party/swig_wrapper && bash build.sh
RUN echo "source $DIRPATH/apollo-platform/ros/install/ros_x86_64/setup.bash" >> $DIRPATH/.bashrc
