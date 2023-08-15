# Use react-native-android as the base image
FROM reactnativecommunity/react-native-android:latest

# Set up environment variables
ENV     LANG        C.UTF-8
ENV     LC_ALL      C.UTF-8

# Install NVM
ENV     NVM_DIR     /root/.nvm
RUN     mkdir -p    $NVM_DIR
RUN     curl -o-    https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# The following lines make NVM available in the shell without having to source anything
ENV     NODE_VERSION 20.5.0
RUN     /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default"

# This makes NVM and the right Node version available to the shell
ENV     PATH        $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Print nvm/node/npm versions
RUN     node -v
RUN     npm -v

# Install Ruby and Ruby dependencies for Fastlane
RUN     apt-get update && apt-get install -y \
        ruby-full \
        build-essential \
        ruby-bundler

# Install Fastlane
RUN     gem install fastlane -NV -v 2.213.0

# Install OpenJDK 11
RUN     apt-get install -y openjdk-11-jdk

# Set JAVA_HOME to the location of OpenJDK 11
ENV     JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Set Android SDK environment variables
ENV     PATH $PATH:/opt/android/build-tools/30.0.2/

# Clean up
RUN     apt-get clean

# Create app directory
WORKDIR /usr/src/app

# Create android local.properties with sdk.dir
RUN     mkdir -p android && echo "sdk.dir=${ANDROID_SDK_ROOT}" > android/local.properties
