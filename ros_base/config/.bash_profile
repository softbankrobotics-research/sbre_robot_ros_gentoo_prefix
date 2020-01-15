./gentoo/startprefix
source /tmp/gentoo/opt/ros/kinetic/setup.bash
export CATKIN_PREFIX_PATH=/tmp/gentoo/opt/ros/kinetic

# The ros ip use WLAN0 by default if you want to use ETH0 by default comment
# the section below and uncomment the section that use ETH0 by default

export ROS_IP=$(ifconfig wlan0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')
if [ -z "$ROS_IP" ]
then
    export ROS_IP=$(ifconfig eth0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')
fi

# The ros ip use ETH0 by default if you want to use WLAN0 by default comment
# the section below and uncomment the section that use WLAN0 by default

#export ROS_IP=$(ifconfig eth0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')
#if [ -z "$ROS_IP" ]
#then
#    export ROS_IP=$(ifconfig wlan0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')
#fi

export NAO_IP=$ROS_IP
export ROS_MASTER_URI=http://$ROS_IP:11311