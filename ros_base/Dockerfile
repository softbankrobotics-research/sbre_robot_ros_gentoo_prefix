FROM gentoo_emerge_xenial
WORKDIR /home/user
USER user

RUN bash /tmp/gentoo/executeonprefix emerge --version

ENV PREFIXED=/tmp/gentoo/executeonprefix
ENV EPREFIX=/tmp/gentoo

# UTF-8 and locale-gen
RUN echo "en_US.UTF-8 UTF-8" >> $EPREFIX/etc/locale.gen
RUN $PREFIXED locale-gen

RUN $PREFIXED emerge --sync
RUN $PREFIXED emerge --oneshot portage

# Install git
RUN $PREFIXED emerge dev-vcs/git

# Setting up ros-overlay https://github.com/ros/ros-overlay
RUN mkdir -p /tmp/gentoo/etc/portage/repos.conf && echo "[ros-overlay]\n\
location = /tmp/gentoo/var/repo/ros-overlay\n\
sync-type = git\n\
sync-uri = https://github.com/ros/ros-overlay\n\
auto-sync = yes\n\
masters = gentoo" > /tmp/gentoo/etc/portage/repos.conf/ros-overlay.conf

# Set up Gentoo to sync via git (way faster)
RUN rm -rf $EPREFIX/usr/portage && echo "[DEFAULT]\n\
main-repo = gentoo\n\
\n\
[gentoo]\n\
location = /tmp/gentoo/usr/portage\n\
sync-type = git\n\
sync-uri = https://github.com/gentoo-mirror/gentoo \n\
auto-sync = yes" > $EPREFIX/etc/portage/repos.conf/gentoo.conf

# Sync everything
RUN $PREFIXED emaint sync -a
RUN $PREFIXED emerge --oneshot portage

# Config in python 2.7
RUN echo "# From the Docker image of ros-overlay\n\
# mainly force to build just Python 2.7\n\
ros-kinetic/* PYTHON_TARGETS: -* python2_7\n\
ros-kinetic/* PYTHON_SINGLE_TARGET: -* python2_7\n\
ros-lunar/* PYTHON_TARGETS: -* python2_7\n\
ros-lunar/* PYTHON_SINGLE_TARGET: -* python2_7\n\
" >> $EPREFIX/etc/portage/package.use

# Package.mask config
RUN echo ">=dev-lisp/sbcl-1.5.0" >> /tmp/gentoo/etc/portage/package.mask
RUN echo ">=dev-python/wxpython-4.0.6" >> /tmp/gentoo/etc/portage/package.mask

# sync ros-overlay
RUN $PREFIXED emaint sync -r ros-overlay

# Package.use config
RUN echo ">=dev-libs/boost-1.71.0 python" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=x11-libs/wxGTK-3.0.4-r2:3.0 tiff" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=x11-libs/pango-1.42.4-r2 X" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=x11-libs/cairo-1.16.0-r3 X" >> /tmp/gentoo/etc/portage/package.use
RUN echo "sys-libs/libcap -pam" >> $EPREFIX/etc/portage/package.use

# Patches for message_filters, roscpp and actionlib
RUN mkdir -p /tmp/gentoo/etc/portage/patches/ros-kinetic/message_filters
COPY patches/0001-Remove-signals-to-enable-compilation-to-go-thru-message-filters.patch /tmp/gentoo/etc/portage/patches/ros-kinetic/message_filters/0001-Remove-signals-to-enable-compilation-to-go-thru-message-filters.patch
RUN mkdir -p /tmp/gentoo/etc/portage/patches/ros-kinetic/roscpp
COPY patches/0001-Remove-signals-to-enable-compilation-to-go-thru.patch /tmp/gentoo/etc/portage/patches/ros-kinetic/roscpp/0001-Remove-signals-to-enable-compilation-to-go-thru.patch
RUN mkdir -p /tmp/gentoo/etc/portage/patches/ros-kinetic/actionlib
COPY patches/0001-Boost-milliseconds-long-patch-on-floats.patch /tmp/gentoo/etc/portage/patches/ros-kinetic/actionlib/0001-Boost-milliseconds-long-patch-on-floats.patch

# Quick Fix before next PR
RUN rm /tmp/gentoo/var/repo/ros-overlay/ros-kinetic/catkin/files/0001-Workaround-error-issue-ros-overlay-711.patch
RUN $PREFIXED ebuild /tmp/gentoo/var/repo/ros-overlay/ros-kinetic/catkin/*.ebuild manifest

# Install ros_base
RUN $PREFIXED emerge ros-kinetic/ros_base

# Patches for tf2 and tf
RUN mkdir -p $EPREFIX/etc/portage/patches/ros-kinetic/tf2
COPY patches/0001-Remove-signals-to-enable-build.patch $EPREFIX/etc/portage/patches/ros-kinetic/tf2
RUN mkdir -p $EPREFIX/etc/portage/patches/ros-kinetic/tf
COPY patches/0001-Remove-signals-so-to-build-with-boost-1.71.0.patch $EPREFIX/etc/portage/patches/ros-kinetic/tf/0001-Remove-signals-so-to-build-with-boost-1.71.0.patch

# Package.use config
RUN echo "sys-libs/libcap -pam" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=media-libs/gd-2.2.5-r2 jpeg truetype fontconfig png" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-python/PyQt5-5.13.2 gui widgets" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=x11-libs/libxcb-1.13.1 xkb" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=x11-libs/libxkbcommon-0.9.1 X" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-libs/libpcre2-10.34 pcre16" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=sys-libs/zlib-1.2.11-r2 minizip" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=sci-libs/vtk-8.1.0-r3 qt5 rendering" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/did_you_mean-1.3.1 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/minitest-5.13.0 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/net-telnet-0.2.0 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/power_assert-1.1.5 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/rake-13.0.1 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/test-unit-3.3.4 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/xmlrpc-0.3.0 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/bundler-1.17.3 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/json-2.2.0 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/rdoc-6.1.2 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=virtual/rubygems-15 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/rubygems-3.0.6 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/kpeg-1.1.0-r1 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-ruby/racc-1.4.14 ruby_targets_ruby26" >> /tmp/gentoo/etc/portage/package.use
RUN echo "dev-qt/qtgui -libinput -udev" >> /tmp/gentoo/etc/portage/package.use

# Package.mask config
RUN echo ">=sys-libs/libcap-2.28" >> /tmp/gentoo/etc/portage/package.mask
RUN echo ">dev-games/ogre-1.9.0-r1" >> /tmp/gentoo/etc/portage/package.mask

# Installation needed before libqi and libqicore
RUN $PREFIXED emerge dev-games/ogre
RUN $PREFIXED emerge dev-qt/qtcore dev-qt/qtgui
RUN $PREFIXED emerge dev-qt/qttest dev-qt/qtconcurrent dev-qt/qtwidgets dev-python/PyQt5[gui,widgets]
RUN $PREFIXED emerge dev-python/pip
RUN $PREFIXED emerge ros-kinetic/opencv3
RUN $PREFIXED emerge media-libs/opencv
RUN $PREFIXED emerge ros-kinetic/cv_bridge
RUN $PREFIXED emerge ros-kinetic/geometry_msgs
RUN $PREFIXED emerge ros-kinetic/image_transport
RUN $PREFIXED emerge ros-kinetic/diagnostic_updater
RUN rm /tmp/gentoo/var/repo/ros-overlay/ros-kinetic/orocos_kdl/files/*
RUN $PREFIXED ebuild /tmp/gentoo/var/repo/ros-overlay/ros-kinetic/orocos_kdl/*.ebuild manifest
RUN $PREFIXED emerge ros-kinetic/robot_state_publisher
RUN $PREFIXED emerge ros-kinetic/tf2_geometry_msgs

# Patches for libqi and libqicore
RUN mkdir -p /tmp/gentoo/etc/portage/patches/ros-kinetic/naoqi_libqi-2.5.0-r3
COPY patches/libqi-release.patch /tmp/gentoo/etc/portage/patches/ros-kinetic/naoqi_libqi-2.5.0-r3/libqi-release.patch
RUN mkdir -p /tmp/gentoo/etc/portage/patches/ros-kinetic/naoqi_libqicore-2.3.1-r1
COPY patches/libqicore-release.patch /tmp/gentoo/etc/portage/patches/ros-kinetic/naoqi_libqicore-2.3.1-r1/libqicore-release.patch

#install libqi and libqicore
RUN $PREFIXED emerge ros-kinetic/naoqi_libqi
RUN $PREFIXED emerge ros-kinetic/naoqi_libqicore


RUN cd /tmp; tar cvzf sbre_robot_ros_kinetic_gentoo_prefix.tar.gz gentoo