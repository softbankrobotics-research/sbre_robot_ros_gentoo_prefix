FROM gentoo_emerge_bionic
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

# Patches for message_filters and roscpp
RUN mkdir -p /tmp/gentoo/etc/portage/patches/ros-melodic/message_filters
COPY patches/0001-Remove-signals-to-enable-compilation-to-go-thru-message-filters.patch /tmp/gentoo/etc/portage/patches/ros-melodic/message_filters/0001-Remove-signals-to-enable-compilation-to-go-thru-message-filters.patch
RUN mkdir -p /tmp/gentoo/etc/portage/patches/ros-melodic/roscpp
COPY patches/0001-Remove-signals-to-enable-compilation-to-go-thru.patch /tmp/gentoo/etc/portage/patches/ros-melodic/roscpp/0001-Remove-signals-to-enable-compilation-to-go-thru.patch

# Install ros_base
RUN $PREFIXED emerge ros-melodic/ros_base

# Patches for tf2 and tf
RUN mkdir -p $EPREFIX/etc/portage/patches/ros-melodic/tf2
COPY patches/0001-Remove-signals-to-enable-build.patch $EPREFIX/etc/portage/patches/ros-melodic/tf2.patch
RUN mkdir -p $EPREFIX/etc/portage/patches/ros-melodic/tf
COPY patches/0001-Remove-signals-so-to-build-with-boost-1.71.0.patch $EPREFIX/etc/portage/patches/ros-melodic/tf/0001-Remove-signals-so-to-build-with-boost-1.71.0.patch

# Package.use config
RUN echo ">=media-libs/gd-2.2.5-r2 jpeg truetype fontconfig png" >> /tmp/gentoo/etc/portage/package.use

# Installation needed for libqi and libqicore
RUN $PREFIXED emerge =media-libs/opencv-3.4.1-r7
RUN $PREFIXED emerge ros-melodic/cv_bridge
RUN $PREFIXED emerge ros-melodic/geometry_msgs
RUN $PREFIXED emerge ros-melodic/diagnostic_updater
RUN $PREFIXED emerge ros-melodic/robot_state_publisher
RUN $PREFIXED emerge ros-melodic/tf2_geometry_msgs


RUN cd /tmp; tar cvzf sbre_robot_ros_melodic_gentoo_prefix.tar.gz gentoo