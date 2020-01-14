FROM gentoo_emerge_xenial_32
WORKDIR /home/user
USER user

RUN bash /tmp/gentoo/executeonprefix emerge --version

ENV PREFIXED="linux32 /tmp/gentoo/executeonprefix"
ENV EPREFIX=/tmp/gentoo

# UTF-8 and locale-gen
RUN echo "en_US.UTF-8 UTF-8" >> $EPREFIX/etc/locale.gen
RUN $PREFIXED locale-gen
ENV CHOST i686-pc-linux-gnu

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
RUN $PREFIXED emerge --sync
RUN $PREFIXED emerge --oneshot portage

RUN $PREFIXED eselect python set 2

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

# package.accept_keywords
# Needed to emerge dev-python/rosdep on 32b
RUN echo "# required by dev-python/rosdep-0.13.0::ros-overlay\n\
# required by dev-python/rosdep (argument)\n\
=dev-python/catkin_pkg-9999 **\n\
# required by dev-python/rosdep-0.13.0::ros-overlay\n\
# required by dev-python/rosdep (argument)\n\
=dev-python/rosdistro-9999 **\n\
# required by dev-python/rosdistro-9999::gentoo\n\
# required by dev-python/rosdep-0.13.0::ros-overlay\n\
# required by dev-python/rosdep (argument)\n\
=dev-python/rospkg-9999 **\n\
=dev-libs/console_bridge-9999 **" >> $EPREFIX/etc/portage/package.accept_keywords

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
COPY patches/0001-Remove-signals-to-enable-build.patch $EPREFIX/etc/portage/patches/ros-kinetic/tf2/0001-Remove-signals-to-enable-build.patch
RUN mkdir -p $EPREFIX/etc/portage/patches/ros-kinetic/tf
COPY patches/0001-Remove-signals-so-to-build-with-boost-1.71.0.patch $EPREFIX/etc/portage/patches/ros-kinetic/tf/0001-Remove-signals-so-to-build-with-boost-1.71.0.patch

# Package.use config
RUN echo ">=media-libs/gd-2.2.5-r2 jpeg truetype fontconfig png" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=x11-libs/libxcb-1.13.1 xkb" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=x11-libs/libxkbcommon-0.9.1 X" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=dev-libs/libpcre2-10.34 pcre16" >> /tmp/gentoo/etc/portage/package.use
RUN echo ">=sci-libs/vtk-8.1.0-r3 qt5 rendering" >> /tmp/gentoo/etc/portage/package.use

RUN $PREFIXED emerge =media-libs/opencv-3.4.1-r7
RUN $PREFIXED emerge =dev-lang/ruby-2.4.9

# Install dev-qt
RUN echo "dev-qt/qtgui -libinput -udev" >> /tmp/gentoo/etc/portage/package.use
RUN $PREFIXED emerge dev-qt/qtcore dev-qt/qtgui
RUN echo ">=dev-python/PyQt5-5.14.0 gui widgets" >> /tmp/gentoo/etc/portage/package.use
RUN $PREFIXED emerge dev-qt/qttest dev-qt/qtconcurrent dev-qt/qtwidgets dev-python/PyQt5[gui,widgets]

RUN $PREFIXED emerge ros-kinetic/cv_bridge
RUN $PREFIXED emerge ros-kinetic/geometry_msgs
RUN $PREFIXED emerge ros-kinetic/image_transport
RUN $PREFIXED emerge ros-kinetic/diagnostic_updater
RUN rm /tmp/gentoo/var/repo/ros-overlay/ros-kinetic/orocos_kdl/files/*
RUN $PREFIXED ebuild /tmp/gentoo/var/repo/ros-overlay/ros-kinetic/orocos_kdl/*.ebuild manifest

# package.accecpt_keywords for robot_state_publisher
RUN echo "=dev-libs/urdfdom_headers-9999 **" >> $EPREFIX/etc/portage/package.accept_keywords
RUN echo "=dev-libs/urdfdom-9999 **" >> $EPREFIX/etc/portage/package.accept_keywords

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


RUN cd /tmp; tar cvzf sbre_robot_ros_kinetic_gentoo_prefix_32.tar.gz gentoo