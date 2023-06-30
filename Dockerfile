# Use react-native-android as the base image
# FROM tomerh2001/fastlane-firebase:latest

# Use react-native-android as the base image
FROM reactnativecommunity/react-native-android:latest

# Set up environment variables
# fastlane requires some environment variables set up to run correctly. In particular, having your locale not set to a UTF-8 locale will cause issues with building and uploading your build. In your shell profile add the following lines:
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install Ruby and Ruby dependencies for Fastlane
RUN apt-get update && apt-get install -y \
    ruby-full \
    build-essential \
    ruby-bundler

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Install Fastlane
RUN gem install fastlane -NV -v 2.213.0

# Install Firebase CLI
RUN npm install -g firebase-tools

# Install OpenJDK 8
RUN apt-get install -y openjdk-8-jdk

# Set JAVA_HOME to the location of OpenJDK 8
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Clean up
RUN apt-get clean

# Create app directory
WORKDIR /usr/src/app

# Create android local.properties with sdk.dir
RUN mkdir -p android && echo "sdk.dir=${ANDROID_SDK_ROOT}" > android/local.properties

