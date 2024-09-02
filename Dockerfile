FROM debian:bookworm

WORKDIR /app

RUN apt-get update && \
    apt-get install -y software-properties-common

# Need to crease a sources.list file: https://groups.google.com/g/linux.debian.bugs.dist/c/6gM_eBs4LgE
RUN echo "# See sources.lists.d directory" > /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 82B129927FA3303E && \
    apt-add-repository -y -S deb http://archive.raspberrypi.com/debian/ bookworm main

RUN apt-get install -y rpicam-apps libgles2 python3-venv wget meson

RUN apt-get install -y binutils binutils-aarch64-linux-gnu binutils-common build-essential bzip2   cmake cmake-data comerr-dev cpp cpp-12 cppzmq-dev dpkg dpkg-dev fakeroot   ffmpeg fonts-droid-fallback fonts-noto-mono fonts-urw-base35 g++ g++-12 gcc   gcc-12 gdal-data gdal-plugins ghostscript gir1.2-freedesktop   gir1.2-gst-plugins-bad-1.0 gir1.2-gst-plugins-base-1.0 gir1.2-gstreamer-1.0   gir1.2-gudev-1.0 git git-man glib-networking glib-networking-common   glib-networking-services gobject-introspection gsfonts gstreamer1.0-gl   gstreamer1.0-libav gstreamer1.0-libcamera gstreamer1.0-plugins-bad   gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-tools   gstreamer1.0-x ibverbs-providers   icu-devtools imagemagick-6-common javascript-common krb5-multidev less   libaa1 libabsl20220623 libaec0 libalgorithm-diff-perl   libalgorithm-diff-xs-perl libalgorithm-merge-perl libarchive13   libarmadillo11 libarpack2 libasan8 libatomic1 libavcodec-dev libavformat-dev   libavif15 libavutil-dev libbinutils libblkid-dev libblosc1 libbrotli-dev   libbsd-dev libc-bin libc-dev-bin libc-devtools libc6 libc6-dev   libcairo-script-interpreter2 libcairo2-dev libcbor0.8 libcc1-0   libcdparanoia0 libcfitsio10 libcharls2 libcrypt-dev libctf-nobfd0 libctf0   libcurl4 libdc1394-dev libdca0 libde265-0 libdeflate-dev libdirectfb-1.7-7   libdjvulibre-text libdjvulibre21 libdpkg-perl libdrm-dev libdrm-etnaviv1   libdrm-freedreno1 libdrm-tegra0 libdv4 libdvdnav4 libdvdread8 libdw-dev   libegl-dev libelf-dev liberror-perl libevent-core-2.1-7   libevent-pthreads-2.1-7 libexif-dev libexpat1-dev libfaad2 libfabric1   libfakeroot libffi-dev libfftw3-double3 libfido2-1 libfile-fcntllock-perl   libfluidsynth3 libfontconfig-dev libfontenc1 libfreeaptx0 libfreetype-dev   libfreexl1 libfyba0 libgav1-1 libgbm-dev libgcc-12-dev libgd3 libgdal32   libgdbm-compat4 libgdbm6 libgdcm-dev libgdcm3.0 libgeos-c1v5 libgeos3.11.1   libgeotiff5 libgif7 libgirepository1.0-dev libgl-dev libgl2ps1.4 libgles-dev   libgles1 libglew2.2 libglib2.0-dev libglib2.0-dev-bin libglx-dev   libgphoto2-6 libgphoto2-dev libgphoto2-l10n libgphoto2-port12 libgprofng0   libgraphene-1.0-0 libgs-common libgs10 libgs10-common libgssdp-1.6-0   libgssrpc4 libgstreamer-gl1.0-0 libgstreamer-opencv1.0-0   libgstreamer-plugins-bad1.0-0 libgstreamer-plugins-bad1.0-dev   libgstreamer-plugins-base1.0-0 libgstreamer-plugins-base1.0-dev   libgstreamer1.0-dev libgudev-1.0-dev libgupnp-1.6-0 libgupnp-igd-1.0-4   libhdf4-0-alt libhdf5-103-1 libhdf5-hl-100 libheif1 libhwasan0 libibverbs1   libice-dev libicu-dev libidn12 libijs-0.35 libimath-3-1-29 libimath-dev   libinstpatch-1.0-2 libisl23 libitm1 libjansson4 libjbig-dev libjbig2dec0   libjpeg-dev libjpeg62-turbo-dev libjs-jquery libjs-sphinxdoc   libjs-underscore libjson-glib-1.0-0 libjson-glib-1.0-common libjsoncpp25   libjxr-tools libjxr0 libkadm5clnt-mit12 libkadm5srv-mit12 libkate1   libkdb5-10 libkmlbase1 libkmldom1 libkmlengine1 libkrb5-dev libldacbt-enc2   liblept5 liblerc-dev liblocale-gettext-perl liblqr-1-0 liblrdf0 liblsan0   libltc11 libltdl7 liblzma-dev liblzo2-2 libmagickcore-6.q16-6   libmagickcore-6.q16-6-extra libmagickwand-6.q16-6 libmariadb3 libmd-dev   libminizip1 libmjpegutils-2.1-0 libmodplug1 libmount-dev libmpc3 libmpcdec6   libmpeg2encpp-2.1-0 libmpfr6 libmplex2-2.1-0 libmunge2 libncurses6 libneon27   libnetcdf19 libnice10 libnl-3-200 libnl-route-3-200 libnorm-dev libnsl-dev   libnspr4 libnss3 libodbc2 libodbcinst2 libogdi4.1 libopencv-calib3d-dev   libopencv-contrib-dev libopencv-contrib406 libopencv-core-dev libopencv-dev   libopencv-dnn-dev libopencv-features2d-dev libopencv-flann-dev   libopencv-highgui-dev libopencv-highgui406 libopencv-imgcodecs-dev   libopencv-imgcodecs406 libopencv-imgproc-dev libopencv-java libopencv-ml-dev   libopencv-ml406 libopencv-objdetect-dev libopencv-photo-dev   libopencv-photo406 libopencv-shape-dev libopencv-shape406   libopencv-stitching-dev libopencv-stitching406 libopencv-superres-dev   libopencv-superres406 libopencv-video-dev libopencv-video406   libopencv-videoio-dev libopencv-videoio406 libopencv-videostab-dev   libopencv-videostab406 libopencv-viz-dev libopencv-viz406 libopencv406-jni   libopenexr-3-1-30 libopenexr-dev libopengl0 libopenh264-7 libopenmpi3   libopenni2-0 liborc-0.4-0 liborc-0.4-dev liborc-0.4-dev-bin libpaper-utils   libpaper1 libpciaccess-dev libpcre2-32-0 libpcre2-dev libpcre2-posix3   libperl5.36 libpgm-dev libpixman-1-dev libpkgconf3 libpmix2 libpng-dev   libpng-tools libpoppler126 libpopt0 libpq5 libproj25 libproxy1v5   libpthread-stubs0-dev libpython3-dev libpython3.11 libpython3.11-dev   libqhull-r8.0 libqrencode4 libqt5opengl5 libqt5test5 libraptor2-0   libraw1394-dev libraw1394-tools librdmacm1 librhash0 librttopo1 libsbc1   libselinux1-dev libsepol-dev libshout3 libsm-dev libsocket++1 libsodium-dev   libsoundtouch1 libsoup-3.0-0 libsoup-3.0-common libspandsp2 libspatialite7   libsrtp2-1 libstdc++-12-dev libsuperlu5 libswresample-dev libswscale-dev   libsz2 libtag1v5 libtag1v5-vanilla libtbb-dev libtcl8.6 libtesseract5   libtiff-dev libtiffxx6 libtirpc-dev libtk8.6 libtsan2 libubsan1 libucx0   libudev-dev libunwind-dev liburiparser1 libuv1 libv4l-0 libv4lconvert0   libvisual-0.4-0 libvo-aacenc0 libvo-amrwbenc0 libvtk9.1 libwavpack1   libwayland-bin libwayland-dev libwebp-dev libwebpdemux2   libwebrtc-audio-processing1 libwildmidi2 libwmflite-0.2-7 libx11-dev   libx11-xcb-dev libxau-dev libxaw7 libxcb-render0-dev libxcb-shm0-dev   libxcb1-dev libxdmcp-dev libxerces-c3.2 libxext-dev libxft2 libxkbfile1   libxml2-dev libxmu6 libxmuu1 libxpm4 libxrender-dev libxslt1.1 libxt6   libxxf86dga1 libyajl2 libyuv0 libzbar0 libzmq3-dev libzstd-dev libzxing2   linux-libc-dev make manpages manpages-dev mariadb-common mysql-common   netbase opencv-data openssh-client patch perl perl-modules-5.36 pkg-config   pkgconf pkgconf-bin poppler-data proj-bin proj-data python-gi-dev   python3-dev python3-distutils python3-lib2to3 python3-mako python3-markdown   python3-markupsafe python3-numpy python3-opencv python3-pip python3-pygments   python3-setuptools python3-wheel python3-yaml python3.11-dev rpcsvc-proto   rsync sensible-utils timgm6mb-soundfont ucf   unixodbc-common uuid-dev x11-utils x11proto-core-dev x11proto-dev xauth   xfonts-encodings xfonts-utils xorg-sgml-doctools xtrans-dev xz-utils   zlib1g-dev

RUN apt-get install -y hailo-tappas-core-3.28.2 hailofw


RUN git clone https://github.com/hailo-ai/hailo-rpi5-examples.git && \
    cd hailo-rpi5-examples && ./download_resources.sh

RUN mkdir /opt/python3.10

# To avoid .pyc files and save space
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# fix tzdata dialog https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d
ENV TZ=Europe/Paris

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install all dependencies you need to compile Python3.10 and then a wheel for Hailo
RUN apt update --fix-missing
RUN apt install -y wget libffi-dev gcc build-essential curl tcl-dev tk-dev uuid-dev lzma-dev liblzma-dev libssl-dev libsqlite3-dev python3.11-dev dkms git python3.11-venv python3-pip cmake rsync g++-12 gcc-12 linux-headers-generic dpkg expect

RUN mkdir -p /lib/modules/$(uname -r)

RUN ln -s /usr/src/linux-headers-$(uname -r) /lib/modules/$(uname -r)/build

# Download Python source code from official site and build it
RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
RUN tar -zxvf Python-3.10.0.tgz
RUN cd Python-3.10.0 && ./configure --prefix=/opt/python3.10 && make && make install

# Delete the python source code and temp files
RUN rm Python-3.10.0.tgz
RUN rm -r Python-3.10.0/

# Now link it so that $python works
RUN ln -s /opt/python3.10/bin/python3.10 /usr/bin/python

# update pip
RUN python -m pip install --upgrade pip

RUN uname -r
# TÃ©lÃ©charger et installer les en-tÃªtes du noyau
RUN wget https://github.com/raspberrypi/linux/archive/refs/tags/raspberrypi-kernel_1.20210303-1.tar.gz && \
    tar -xzf raspberrypi-kernel_1.20210303-1.tar.gz && \
    cd linux-raspberrypi-kernel_1.20210303-1 && \
    make headers_install INSTALL_HDR_PATH=/usr/src/linux-headers-6.6.31+rpt-rpi-2712 && \
    rm -rf raspberrypi-kernel_1.20210303-1.tar.gz linux-raspberrypi-kernel_1.20210303-1

# copy some files to the image
RUN mkdir /app/hailo_assets
RUN cd /app/hailo_assets/
COPY requirements.txt /app/
COPY hailo_assets/ /app/hailo_assets/

# CrÃ©er un script pour automatiser la rÃ©ponse Ã  la question DKMS
RUN echo '#!/usr/bin/expect -f\n\
spawn dpkg -i /app/hailo_assets/hailort-pcie-driver_4.18.0_all.deb\n\
expect "Do you wish to use DKMS? [Y/n]:"\n\
send "Y\r"\n\
expect eof' > /app/hailo_assets/install_hailort.expect && \
    chmod +x /app/hailo_assets/install_hailort.expect
RUN /app/hailo_assets/install_hailort.expect || apt-get install -f -y

# Cloner le dÃ©pÃ´t HailoRT et installer HailoRT
RUN git clone https://github.com/hailo-ai/hailort.git && \
    cd hailort && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# install HailoRT .deb package
#RUN dpkg -i /app/hailo_assets/hailort_4.18.0_arm64.deb || apt-get install -f -y
RUN /bin/sh -c dpkg -i /app/hailo_assets/hailort_4.18.0_arm64.deb || apt-get install -f -y

# compile HailoRT wheel
RUN python -m pip install /app/hailo_assets/hailort-4.18.0-cp310-cp310-linux_aarch64.whl || true
RUN cat /var/log/hailort-pcie-driver.deb.log || true
RUN python -m pip install -r requirements.txt

# remove copied files to save some space
RUN rm -rf hailo_assets

#CMD ["/bin/sh", "-c", "bash"]
