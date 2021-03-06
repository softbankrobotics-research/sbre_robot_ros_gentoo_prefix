# melodic

You need to install docker first to build the image.

## Build sbre_robot_melodic_gentoo_prefix

Now, you can build ros melodic with:

`docker build --network host -f Dockerfile -t sbre_robot_ros_melodic_gentoo_prefix .`

## Send the gentoo prefix on your robot's head

You have now a docker image with gentoo prefix and ros melodic installed.
To install it on your robot first run your docker image:

`docker run -it sbre_robot_ros_melodic_gentoo_prefix`

Now you can send the compressed file named sbre_robot_ros_melodic_gentoo_prefix.tar.gz
on your robot:

`cd /tmp`

`scp sbre_robot_ros_melodic_gentoo_prefix.tar.gz nao@ROBOT_IP:.`



Ssh on your robot to launch the gentoo prefix:

`ssh nao@ROBOT_IP`

Uncompressed the gentoo prefix on your robot (you can remove the compressed file afterward):

`tar xzf sbre_robot_ros_melodic_gentoo_prefix.tar.gz`

## Use gentoo prefix and ROS

In order to use the gentoo prefix and ros by default you can
send the .bash_profile (ros_base/config/.bash_profile) on the robot's head or follow the next step.

### Use gentoo prefix

Start the gentoo prefix:

`./gentoo/startprefix`

Now you can use emerge and others tools.

### Use ROS

Your are now into the gentoo prefix.
First you need to source ros:

`source /tmp/gentoo/opt/ros/melodic/setup.bash`

Export the catkin prefix path:

`export CATKIN_PREFIX_PATH=/tmp/gentoo/opt/ros/melodic`

Fix the ROS_IP variable with your ROBOT_IP:

`export ROS_IP=ROBOT_IP`

Now you can use catkin_make or roscore

### Libqi and Libqicore

Create your catkin workspace:

`mkdir -p ros_ws/src`

Clone in your catkin workspace libqi-release and libqicore-release in kinetic (Issue for now with melodic version and boost > 1.70):

`cd ros_ws/src`

`git clone --branch release/kinetic/naoqi_libqi https://github.com/ros-naoqi/libqi-release.git`

`git clone --branch release/kinetic/naoqi_libqicore https://github.com/ros-naoqi/libqicore-release.git`

Use the libqi-release.patch and libqicore-release.patch in the patches folder (use scp to send them or create patch files):

`git apply libqi-release.patch`

`git apply libqicore-release.patch`

Compile Libqi and Libqicore:

`cd ~/ros_ws`

`catkin_make`


### Naoqi_driver

Clone in your catkin workspace naoqi_driver and naoqi_bridge_msg:

`cd ros_ws/src`

`git clone https://github.com/ros-naoqi/naoqi_driver.git`

`git clone https://github.com/ros-naoqi/naoqi_bridge_msgs.git`

Compile the naoqi driver:

`cd ~/ros_ws`

`catkin_make`

Before running naoqi_driver, you need to deactivate some modules (in 2.9 some modules' name changed).
Modify the file naoqi_driver/share/boot_config.json with:

`"diag":
    {
      "enabled": false,
      "frequency"     : 1
    }`

`"sonar":
    {
      "enabled":  false,
      "frequency"     : 10
    }`

`"audio":
    {
      "enabled": false
    }`


Now you can launch naoqi_driver:

`source ~/ros_ws/devel/setup.bash`

`roslaunch naoqi_driver naoqi_driver.launch`



