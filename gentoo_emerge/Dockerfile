# Just Ubuntu 16.04 with a user called user and some basic tools
FROM ubuntu:18.04

RUN apt-get update
# Add sudo
RUN apt-get install apt-utils sudo -y

# Create user
RUN useradd --create-home --shell=/bin/bash user
RUN chown -R user /home/user/
# Add the user to sudoers
RUN chmod -R o-w /etc/sudoers.d/
RUN usermod -aG sudo user
# Give the user a password
RUN echo user:user | chpasswd

# Instal basic stuff
RUN apt-get install build-essential -y

# Nice tools to have
RUN apt-get install bash-completion nano net-tools less iputils-ping vim emacs -y
RUN apt-get install python-pip python-dev  -y
RUN apt-get install wget -y
# To enable ssh
RUN apt-get install openssh-server -y
# To enable adding to the clipboard from the shell
RUN apt-get install xclip -y

WORKDIR /home/user
USER user

# Let's get some specs of the machine that is running this job
RUN cat /proc/cpuinfo
RUN cat /proc/meminfo
RUN df -h

# RUN wget https://gitweb.gentoo.org/repo/proj/prefix.git/plain/scripts/bootstrap-prefix.sh
# hack until https://bugs.gentoo.org/699718 is fixed
# It also contains a workaround to be able to bootstrap stages separately while in
# noninteractive mode
COPY --chown=user:user bootstrap-prefix.sh /home/user/bootstrap-prefix.sh
RUN chmod +x bootstrap-prefix.sh
ENV EPREFIX /tmp/gentoo


# Bootstrap Gentoo Prefix
RUN LATEST_TREE_YES=1 TESTING_PV=latest ./bootstrap-prefix.sh ${EPREFIX} noninteractive stage1

# Bootstrap Gentoo Prefix
RUN LATEST_TREE_YES=1 TESTING_PV=latest ./bootstrap-prefix.sh ${EPREFIX} noninteractive stage2

# Bootstrap Gentoo Prefix
RUN LATEST_TREE_YES=1 TESTING_PV=latest ./bootstrap-prefix.sh ${EPREFIX} noninteractive stage3

# Bootstrap Gentoo Prefix
RUN LATEST_TREE_YES=1 TESTING_PV=latest ./bootstrap-prefix.sh ${EPREFIX} noninteractive

# Remove bootstrap-prefix.sh
RUN rm bootstrap-prefix.sh

# Copy own executonprefix and starprefix
RUN mv /tmp/gentoo/startprefix /tmp/gentoo/startprefix_original
COPY prefix/executeonprefix executeonprefix
RUN mv executeonprefix /tmp/gentoo
COPY prefix/startprefix startprefix
RUN mv startprefix /tmp/gentoo

ENTRYPOINT ["/bin/bash"]