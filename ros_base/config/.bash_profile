source gentoo/startprefix
export PYTHONPATH=/home/nao/.local/pynaoqi-python2.7-2.5.5.5-linux32/lib/python2.7/site-packages
source /tmp/gentoo/opt/ros/melodic/setup.bash
export CATKIN_PREFIX_PATH=/tmp/gentoo/opt/ros/melodic

# The ros ip use WLAN0 by default if you want to use ETH0 by default comment
# the section below and uncomment the section that use ETH0 by default

export ROS_IP=$(ip addr show wlan0 | grep -Po '(?<= inet )([0-9]{1,3}.){3}[0-9]{1,3}')
if [ -z "$ROS_IP" ]
then
    export ROS_IP=$(ip addr show eth0 | grep -Po '(?<= inet )([0-9]{1,3}.){3}[0-9]{1,3}')
fi

# The ros ip use ETH0 by default if you want to use WLAN0 by default comment
# the section below and uncomment the section that use WLAN0 by default

#export ROS_IP=$(ip addr show eth0 | grep -Po '(?<= inet )([0-9]{1,3}.){3}[0-9]{1,3}')
#if [ -z "$ROS_IP" ]
#then
#    export ROS_IP=$(ip addr show wlan0 | grep -Po '(?<= inet )([0-9]{1,3}.){3}[0-9]{1,3}')
#fi

export NAO_IP=$ROS_IP
export ROS_MASTER_URI=http://127.0.0.1:11311