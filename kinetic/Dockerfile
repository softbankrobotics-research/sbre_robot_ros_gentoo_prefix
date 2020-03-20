FROM awesomebytes/roogp_ros_kinetic_ros_base:1464

## Config before installations

# Package.use config
RUN echo "dev-qt/qtgui -libinput -udev" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-libs/libpcre2-10.32 pcre16" >> /tmp/gentoo/etc/portage/package.use 
RUN echo ">=media-libs/gd-2.2.5-r1 truetype jpeg png fontconfig" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=x11-libs/libxcb-1.13.1 xkb" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=sci-libs/vtk-8.1.0-r3 rendering qt5" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=x11-libs/libxkbcommon-0.8.2 X" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=sys-libs/zlib-1.2.11-r2 minizip" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-python/PyQt5-5.10.1-r1 gui widgets webkit network printsupport opengl" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/minitest-5.14.0 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/test-unit-3.3.5 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/xmlrpc-0.3.0 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/bundler-2.1.4 ruby_targets_ruby27 -doc" >> $EPREFIX/etc/portage/package.use
RUN echo ">=virtual/rubygems-16 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/power_assert-1.1.5 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/rake-13.0.1 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/did_you_mean-1.4.0 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/net-telnet-0.2.0 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/json-2.3.0 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/rdoc-6.2.0 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/rubygems-3.1.2 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/kpeg-1.1.0-r1 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use
RUN echo ">=dev-ruby/racc-1.4.16-r1 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use


# For https://bugs.gentoo.org/649808
RUN mkdir -p /tmp/gentoo/etc/portage/profile && \
    echo "sys-fs/udev-init-scripts-32" >> /tmp/gentoo/etc/portage/profile/package.provided

# Newer version doesn't emerge cause it wants to link with libudev.so
# and I found no way of emerging it
RUN echo ">media-libs/libv4l-1.10.1" >> /tmp/gentoo/etc/portage/package.mask

# If we can go faster, try
RUN sed -i -e 's/j1/j'"$((`grep -c \^processor \/proc\/cpuinfo` / 2))"'/g' $EPREFIX/etc/portage/make.conf
RUN sed -i -e 's/j2/j'"$((`grep -c \^processor \/proc\/cpuinfo` / 2))"'/g' $EPREFIX/etc/portage/make.conf


## Installation

# Install qt
RUN $PREFIXED emerge dev-qt/qtcore dev-qt/qtgui dev-qt/qttest dev-qt/qtconcurrent dev-qt/qtwidgets

# Patches for libqi and libqicore
RUN mkdir -p /tmp/gentoo/etc/portage/patches/ros-kinetic/naoqi_libqi-2.5.0-r3
COPY patches/libqi-release.patch /tmp/gentoo/etc/portage/patches/ros-kinetic/naoqi_libqi-2.5.0-r3/libqi-release.patch
RUN mkdir -p /tmp/gentoo/etc/portage/patches/ros-kinetic/naoqi_libqicore-2.3.1-r1
COPY patches/libqicore-release.patch /tmp/gentoo/etc/portage/patches/ros-kinetic/naoqi_libqicore-2.3.1-r1/libqicore-release.patch

# Install libqi and libqicore
RUN $PREFIXED emerge ros-kinetic/naoqi_libqi
RUN $PREFIXED emerge ros-kinetic/naoqi_libqicore

# Install dev-python/distro for rospkg
RUN $PREFIXED emerge dev-python/distro

# Taken from awesomebytes/ros_overlay_on_gentoo_prefix_32b ROS desktop Dockerfile3
# As reported here https://github.com/ros/ros-overlay/issues/581
# For cv_bridge, camera_calibration_parsers (at least)
RUN $PREFIXED emerge dev-libs/boost[python]
RUN cd $EPREFIX/usr/lib &&\
    ln -s libboost_python27.so libboost_python.so
# Numpy doesn't support Python 2.7 anymore
# and we are still pending on migrating to Python 3 (as ROS is)
# ros-melodic/opencv_bridge fails to emerge with:
# ImportError: No module named numpy
# CMake Error at src/CMakeLists.txt:25 (message):
#   Could not determine the NumPy include directory, verify that NumPy was
#   installed correctly.
# So we install the latest Python2 compatible numpy version
RUN echo ">dev-python/numpy-1.17" >> $EPREFIX/etc/portage/package.mask && \
    $PREFIXED emerge dev-python/numpy

# Install libraries for Naoqi_driver
RUN $PREFIXED emerge ros-kinetic/cv_bridge
RUN $PREFIXED emerge ros-kinetic/geometry_msgs
RUN $PREFIXED emerge ros-kinetic/image_transport
RUN $PREFIXED emerge ros-kinetic/diagnostic_updater
RUN $PREFIXED emerge ros-kinetic/robot_state_publisher
RUN $PREFIXED emerge ros-kinetic/tf2_geometry_msgs

RUN cd /tmp; tar czf sbre_robot_ros_kinetic_gentoo_prefix.tar.gz gentoo