FROM ros:noetic-ros-base

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libpcl-dev \
    libtbb-dev \
    libomp-dev \
    nlohmann-json3-dev \
    ros-noetic-pcl-ros \
    ros-noetic-roscpp \
    ros-noetic-sensor-msgs \
    ros-noetic-std-msgs \
    ros-noetic-tf \
 && rm -rf /var/lib/apt/lists/*

# Set up catkin workspace
ENV CATKIN_WS=/catkin_ws
RUN mkdir -p $CATKIN_WS/src
WORKDIR $CATKIN_WS

# Copy source
COPY . $CATKIN_WS/src/radar4motion

# Build
RUN . /opt/ros/noetic/setup.sh && \
    catkin_make -C $CATKIN_WS

# Source environment
RUN echo "source $CATKIN_WS/devel/setup.bash" >> /ros_entrypoint.sh

WORKDIR $CATKIN_WS

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["roslaunch", "radar4motion", "radar4motion_offline.launch"]
