# sbre_robot_ros_gentoo_prefix
Build a gentoo prefix with ros to be able to launch ros on the pepper's and nao's head, be able to use emerge or catkin_make... This repository is based on the work of [Sam Pfeiffer](https://github.com/awesomebytes) and more specially on three repositories:
* https://github.com/awesomebytes/gentoo_prefix_ci
* https://github.com/awesomebytes/ros_overlay_on_gentoo_prefix
* https://github.com/awesomebytes/pepper_os

## Naoqi 2.5 (Not ready yet)

Use the branch ros_kinetic_32

## Naoqi 2.9

Use the branch ros_kinetic or ros_melodic

# Docker image

All build can be found on docker hub [here](https://hub.docker.com/r/mcaniot/sbre_robot_ros_gentoo_prefix). You can also pull the latest version with these commands:

ros_kinetic_32 : `to build`

ros_kinetic : `docker pull mcaniot/sbre_robot_ros_gentoo_prefix:sbre_robot_ros_kinetic_gentoo_prefix`

ros_melodic : `docker pull mcaniot/sbre_robot_ros_gentoo_prefix:sbre_robot_ros_melodic_gentoo_prefix`
