FROM ubuntu:16.04
#FROM python:3.6
MAINTAINER Francis Charette Migneault <francis.charette.migneault@gmail.com>

ENV MINICONDA_VERSION=3-latest-Linux-x86_64
ENV CMAKE_VERSION=3.5.1
ENV OPENCV_VERSION=3.4.1
ENV BOOST_VERSION=1.66.0
ENV BOOST_VERSION_DIR=boost_1_66_0

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get -qq update && apt-get install -q -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt-get update 
#RUN apt-get install gcc-5 g++-5
RUN apt-get install -y \
    build-essential \
    ca-certificates \
    git \
    wget \
    curl \
    dpkg \
    grep \
    sed \
    bzip2 \
    unzip \
    yasm \
    pkg-config \
    libboost-dev \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libjasper-dev \
    libavformat-dev \
    libpq-dev \
    libglib2.0-0 \
    libxext6 \ 
    libsm6 \ 
    libxrender1 
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
RUN gcc --version

ENV PATH /opt/conda/bin:$PATH
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda${MINICONDA_VERSION}.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN pip install --upgrade pip
RUN pip install numpy

RUN cd /usr/local/src \ 
    && wget https://cmake.org/files/v${CMAKE_VERSION%.*}/cmake-${CMAKE_VERSION}.tar.gz \
    && tar xvf cmake-${CMAKE_VERSION}.tar.gz \ 
    && cd cmake-${CMAKE_VERSION} \
    && ./bootstrap \
    && make -j4 \
    && make install \
    && cd .. \
    && rm -rf cmake*
RUN cmake --version

WORKDIR /
RUN wget --no-check-certificate --max-redirect 3 https://dl.bintray.com/boostorg/release/${BOOST_VERSION}/source/${BOOST_VERSION_DIR}.tar.gz
RUN tar zxf ${BOOST_VERSION_DIR}.tar.gz \
    && rm ${BOOST_VERSION_DIR}.tar.gz \
    && cd ${BOOST_VERSION_DIR} \
    && ./bootstrap.sh \
    && ./b2 --prefix=/usr/local/ -j4 link=shared runtime-link=shared install \
    && cd .. && rm -rf ${BOOST_VERSION_DIR} && ldconfig

WORKDIR /
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
    && unzip ${OPENCV_VERSION}.zip \
    && mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
    && cd /opencv-${OPENCV_VERSION}/cmake_binary \
    && cmake -DBUILD_TIFF=ON \
    -DBUILD_opencv_java=OFF \
    -DWITH_CUDA=OFF \
    -DENABLE_AVX=ON \
    -DWITH_OPENGL=ON \
    -DWITH_OPENCL=ON \
    -DWITH_IPP=ON \
    -DWITH_TBB=ON \
    -DWITH_EIGEN=ON \
    -DWITH_V4L=ON \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=$(python3.6 -c "import sys; print(sys.prefix)") \
    -DPYTHON_EXECUTABLE=$(which python3.6) \
    -DPYTHON_INCLUDE_DIR=$(python3.6 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -DPYTHON_PACKAGES_PATH=$(python3.6 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. \
    && make install \
    && rm /${OPENCV_VERSION}.zip \
    && rm -r /opencv-${OPENCV_VERSION}

