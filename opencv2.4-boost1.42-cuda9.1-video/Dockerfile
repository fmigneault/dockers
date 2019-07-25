FROM nvidia/cuda:9.1-devel-ubuntu16.04
LABEL maintainer="Francis Charette Migneault" email="francis.charette.migneault@gmail.com"

ENV CMAKE_VERSION=3.5.1
ENV CMAKE_THREADS=4
ENV OPENCV_VERSION=2.4.13.7
ENV BOOST_VERSION=1.42

RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    automake \
    cmake \
    yasm \
    git \
    dos2unix \
    pkg-config \
    texinfo \
    wget \
    curl \
    unzip \
    python \
    python-dev \
    python-numpy \
    libboost${BOOST_VERSION}-dev \
    libtbb2 \
    libtool \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libx264-dev \
    libjasper-dev \
    libeigen3-dev \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.xz && \
    tar xvf nasm-2.13.01.tar.xz && rm nasm-2.13.01.tar.xz && cd nasm-2.13.01 && \
    ./configure \
        --prefix=/usr && \
    make -j${CMAKE_THREADS} && make install && make distclean

WORKDIR /
RUN wget http://download.videolan.org/pub/x264/snapshots/x264-snapshot-20170614-2245-stable.tar.bz2 && \
    tar xjvf x264-snapshot-20170614-2245-stable.tar.bz2 && rm x264-snapshot-20170614-2245-stable.tar.bz2 && cd x264-snapshot-20170614-2245-stable && \
    ./configure \
        --enable-static \
        --enable-pic && \
    make -j${CMAKE_THREADS} && make install && make distclean

WORKDIR /
RUN wget http://ffmpeg.org/releases/ffmpeg-3.3.tar.bz2 && \
    tar xjvf ffmpeg-3.3.tar.bz2 && rm ffmpeg-3.3.tar.bz2 && cd ffmpeg-3.3 && \
    ./configure \
        --pkg-config-flags="--static" \
        --enable-shared \
        --disable-static \
        --enable-gpl \
        --enable-nonfree \
        --enable-libx264 \
        --enable-pic \
        --enable-version3 \
        --enable-runtime-cpudetect && \
    make -j${CMAKE_THREADS} && make install && make distclean

RUN git clone -b ${OPENCV_VERSION} --progress --verbose --single-branch https://github.com/opencv/opencv.git /opencv
WORKDIR /opencv/build
RUN sed -i -e 's/libavformat\.a/libavformat.so/g' \
        -e 's/libavutil\.a/libavutil.so/g' \
        -e 's/libswscale\.a/libswscale.so/g' \
        -e 's/libavresample\.a/libavresample.so/g' \
        -e 's/libavcodec\.a/libavcodec.so/g' \
        ../cmake/OpenCVFindLibsVideo.cmake && \
    ## -- fix erroneous cuda commands
    # see: https://stackoverflow.com/questions/46584000/cmake-error-variables-are-set-to-notfound?answertab=active#tab-top
    sed -i -e 's/find_cuda_helper_libs(nppi)/ \
        find_cuda_helper_libs(nppial)\n \
        find_cuda_helper_libs(nppicc)\n \
        find_cuda_helper_libs(nppicom)\n \
        find_cuda_helper_libs(nppidei)\n \
        find_cuda_helper_libs(nppif)\n \
        find_cuda_helper_libs(nppig)\n \
        find_cuda_helper_libs(nppim)\n \
        find_cuda_helper_libs(nppist)\n \
        find_cuda_helper_libs(nppisu)\n \
        find_cuda_helper_libs(nppitc)\n/g' \
        ../cmake/FindCUDA.cmake && \
    sed -i -e 's/set(CUDA_npp_LIBRARY "${CUDA_nppc_LIBRARY};${CUDA_nppi_LIBRARY};${CUDA_npps_LIBRARY}")/ \
        set(CUDA_npp_LIBRARY ${CUDA_nppc_LIBRARY} ${CUDA_nppial_LIBRARY} ${CUDA_nppicc_LIBRARY} ${CUDA_nppicom_LIBRARY} \
                             ${CUDA_nppidei_LIBRARY} ${CUDA_nppif_LIBRARY} ${CUDA_nppig_LIBRARY} ${CUDA_nppim_LIBRARY}  \
                             ${CUDA_nppist_LIBRARY} ${CUDA_nppisu_LIBRARY} ${CUDA_nppitc_LIBRARY} ${CUDA_npps_LIBRARY})/g' \
        ../cmake/FindCUDA.cmake && \
    sed -i -e 's/unset(CUDA_nppi_LIBRARY CACHE)/ \
        unset(CUDA_nppial_LIBRARY CACHE)\n \
        unset(CUDA_nppicc_LIBRARY CACHE)\n \
        unset(CUDA_nppicom_LIBRARY CACHE)\n \
        unset(CUDA_nppidei_LIBRARY CACHE)\n \
        unset(CUDA_nppif_LIBRARY CACHE)\n \
        unset(CUDA_nppig_LIBRARY CACHE)\n \
        unset(CUDA_nppim_LIBRARY CACHE)\n \
        unset(CUDA_nppist_LIBRARY CACHE)\n \
        unset(CUDA_nppisu_LIBRARY CACHE)\n \
        unset(CUDA_nppitc_LIBRARY CACHE)/g' \
        ../cmake/FindCUDA.cmake && \
    sed -i -e 's/if(NOT DEFINED __cuda_arch_bin)/ \
        set(__cuda_arch_bin "3.0 3.5 3.7 5.0 5.2 6.0 6.1")\n \
        if(NOT DEFINED __cuda_arch_bin)/g' \
        ../cmake/OpenCVDetectCUDA.cmake && \
    ## -- end of cuda fix
    ## help finding cuda libs
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH && ldconfig && \
    ## build opencv
    cmake \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
        -D BUILD_DOCS=OFF \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D WITH_OPENMP=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_CUDA=ON \
        .. && \
    make -j${CMAKE_THREADS} install && rm -r /opencv/build

RUN ldconfig
WORKDIR /
CMD ["/bin/bash"]
