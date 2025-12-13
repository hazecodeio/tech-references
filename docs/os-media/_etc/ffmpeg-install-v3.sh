#tag::apt[]
sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev
#end::apt[]

#  libgnutls28-dev \



#tag::apt2[]
#sudo apt install libunistring-dev libaom-dev libdav1d-dev
#end::apt2[]













#tag::exports[]
export FFMPEG_NAME=ffmpeg
export FFMPEG_HOME=/opt/_tools-os/$FFMPEG_NAME
export FFMPEG_SOURCES=$FFMPEG_HOME/ffmpeg-resources
export FFMPEG_BIN=$FFMPEG_HOME/bin
export FFMPEG_BUILD=$FFMPEG_HOME/ffmpeg-build
export FFMPEG_PKG_CONFIG=$FFMPEG_BUILD/lib/pkgconfig
export FF_I=-I$FFMPEG_BUILD/include
export FF_L=-L$FFMPEG_BUILD/lib
#end::exports[]



#tag::resources[]
mkdir -p $FFMPEG_SOURCES $FFMPEG_BIN
#end::resources[]



#tag::nasm[]
cd $FFMPEG_SOURCES && \
wget https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.bz2 && \
tar xjvf nasm-2.16.03.tar.bz2 && \
cd nasm-2.16.03 && \
./autogen.sh && \
PATH="$FFMPEG_BIN:$PATH" ./configure --prefix="$FFMPEG_BUILD" --bindir="$FFMPEG_BIN" && \
make && \
make install && \
cd $FFMPEG_HOME
#end::nasm[]




#tag::libx264[]
cd $FFMPEG_SOURCES && \
git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
cd x264 && \
PATH="$FFMPEG_BIN:$PATH" PKG_CONFIG_PATH="$FFMPEG_PKG_CONFIG" ./configure --prefix="$FFMPEG_BUILD" --bindir="$FFMPEG_BIN" --enable-static --enable-pic && \
PATH="$FFMPEG_BIN:$PATH" make && \
make install && 
cd $FFMPEG_HOME
#end::libx264[]




#tag::libx265[]
sudo apt-get install libnuma-dev && \
cd $FFMPEG_SOURCES && \
wget -O x265.tar.bz2 https://bitbucket.org/multicoreware/x265_git/get/master.tar.bz2 && \
tar xjvf x265.tar.bz2 && \
cd multicoreware*/build/linux && \
PATH="$FFMPEG_BIN:$PATH" PKG_CONFIG_PATH="$FFMPEG_PKG_CONFIG" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$FFMPEG_BUILD" -DENABLE_SHARED=off ../../source && \
PATH="$FFMPEG_BIN:$PATH" make && \
make install && \
cd $FFMPEG_HOME
#end::libx265[]




#tag::libvpx[]
cd $FFMPEG_SOURCES && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
PATH="$FFMPEG_BIN:$PATH" PKG_CONFIG_PATH="$FFMPEG_PKG_CONFIG" ./configure --prefix="$FFMPEG_BUILD" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
PATH="$FFMPEG_BIN:$PATH" make && \
make install && \
cd $FFMPEG_HOME
#end::libvpx[]




#tag::libfdk-aac[]
cd $FFMPEG_SOURCES && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="$FFMPEG_BUILD" --disable-shared && \
make && \
make install && 
cd $FFMPEG_HOME
#end::libfdk-aac[]




#tag::libopus[]
cd $FFMPEG_SOURCES && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="$FFMPEG_BUILD" --disable-shared && \
make && \
make install && 
cd $FFMPEG_HOME
#end::libopus[]




#tag::libaom[]
cd $FFMPEG_SOURCES && \
git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
mkdir -p aom_build && \
cd aom_build && \
PATH="$FFMPEG_BIN:$PATH" PKG_CONFIG_PATH="$FFMPEG_PKG_CONFIG" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$FFMPEG_BUILD" -DENABLE_TESTS=OFF -DENABLE_NASM=on ../aom && \
PATH="$FFMPEG_BIN:$PATH" make && \
make install && \
cd $FFMPEG_HOME
#end::libaom[]




#tag::libsvtav1[]
cd $FFMPEG_SOURCES && \
git -C SVT-AV1 pull 2> /dev/null || git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git && \
mkdir -p SVT-AV1/build && \
cd SVT-AV1/build && \
PATH="$FFMPEG_BIN:$PATH" PKG_CONFIG_PATH="$FFMPEG_PKG_CONFIG" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$FFMPEG_BUILD" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF .. && \
PATH="$FFMPEG_BIN:$PATH" make && \
make install && 
cd $FFMPEG_HOME
#end::libsvtav1[]




#tag::libdav1d[]
cd $FFMPEG_SOURCES && \
git -C dav1d pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/dav1d.git && \
mkdir -p dav1d/build && \
cd dav1d/build && \
PATH="$FFMPEG_BIN:$PATH" meson setup -Denable_tools=false -Denable_tests=false --default-library=static .. --prefix "$FFMPEG_BUILD" --libdir="$FFMPEG_BUILD/lib" && \
ninja && \
ninja install &&
cd $FFMPEG_HOME
#end::libdav1d[]





#tag::libvmaf[]
cd $FFMPEG_SOURCES && \
git clone 'https://github.com/Netflix/vmaf' 'vmaf-master' &&
mkdir -p 'vmaf-master/libvmaf/build' &&
cd 'vmaf-master/libvmaf/build' &&
PATH="$FFMPEG_BIN:$PATH" meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=static ../ --prefix "$FFMPEG_BUILD" --bindir="$FFMPEG_BUILD/bin" --libdir="$FFMPEG_BUILD/lib" && \
ninja && \
ninja install &&
cd $FFMPEG_HOME
#end::libvmaf[]


#tag::FFmpeg[]
cd $FFMPEG_SOURCES && \
wget -O ffmpeg-8.0.1.tar.bz2 https://ffmpeg.org/releases/ffmpeg-8.0.1.tar.bz2 && \
tar xjvf ffmpeg-8.0.1.tar.bz2 && \
cd ffmpeg-8.0.1 && \
PATH="$FFMPEG_BIN:$PATH" PKG_CONFIG_PATH="$FFMPEG_PKG_CONFIG" ./configure \
  --prefix="$FFMPEG_BUILD" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$FFMPEG_BUILD/include" \
  --extra-ldflags="-L$FFMPEG_BUILD/lib" \
  --extra-libs="-lpthread -lm" \
  --ld="g++" \
  --arch=amd64 \
  --bindir="$FFMPEG_BIN" \
  --enable-gpl \
  --enable-gnutls \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libsvtav1 \
  --enable-libdav1d \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree && \
PATH="$FFMPEG_BIN:$PATH" make && \
make install && \
hash -r &&
cd $FFMPEG_HOME
#end::FFmpeg[]

