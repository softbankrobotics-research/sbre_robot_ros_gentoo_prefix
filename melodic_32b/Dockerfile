FROM awesomebytes/roogp_32b_ros_melodic_ros_base:1467

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
# From awesomebytes/ros_overlay_on_gentoo_prefix desktop Dockerfile
# cv_bridge wants openCV 3, but we have 4 right now, so we need to downgrade
# or do something like: https://github.com/MartinNievas/vision_opencv/pull/2/files
# to allow OpenCV4, but I'll leave that as a future work
RUN echo ">media-libs/opencv-4" >> $EPREFIX/etc/portage/package.mask &&\
    $PREFIXED emerge media-libs/opencv
RUN $PREFIXED emerge ros-melodic/cv_bridge
RUN $PREFIXED emerge ros-melodic/geometry_msgs
RUN $PREFIXED emerge ros-melodic/diagnostic_updater
# Meanwhile tf2 is not correctly regenerated in ros-overlay to 0.6.6-1
RUN wget https://gist.githubusercontent.com/awesomebytes/0564296907ff82603376fcecca60d3d3/raw/b5285a1f65b96c29e4ebb9ad46ae551b0818d543/tf2-0.6.6-1.ebuild -O $EPREFIX/usr/local/portage/ros-melodic/tf2/tf2-0.6.6-r1.ebuild &&\
    $PREFIXED ebuild $EPREFIX/usr/local/portage/ros-melodic/tf2/tf2-0.6.6-r1.ebuild manifest &&\
    $PREFIXED emerge ros-melodic/tf2
# Meanwhile a version newer than tf-1.12.0 is not released (for the boost patch)
RUN mkdir -p $EPREFIX/etc/portage/patches/ros-melodic/tf-1.12.0 &&\
    wget https://gist.githubusercontent.com/awesomebytes/cee46d45d1314d8df4512ed577c55227/raw/4a5edd58e84a0fa010089da7bdf6caa934d6936d/boost_signals_tf_1.12.0.patch -O $EPREFIX/etc/portage/patches/ros-melodic/tf-1.12.0/boost_signals.patch &&\
    $PREFIXED emerge ros-melodic/tf
RUN $PREFIXED emerge ros-melodic/robot_state_publisher
RUN $PREFIXED emerge ros-melodic/tf2_geometry_msgs

RUN cd /tmp; tar czf sbre_robot_ros_melodic_32b_gentoo_prefix.tar.gz gentoo