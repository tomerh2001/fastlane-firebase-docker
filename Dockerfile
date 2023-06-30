# Use react-native-android as the base image
FROM reactnativecommunity/react-native-android:latest

# Install Ruby and Ruby dependencies for Fastlane
RUN apt-get update && apt-get install -y \
    ruby-full \
    build-essential \
    ruby-bundler

# Install Fastlane
RUN gem install fastlane -NV -v 2.213.0

# Install Firebase CLI
RUN npm install -g firebase-tools

# Clean up
RUN apt-get clean

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

# Create android local.properties with sdk.dir
RUN mkdir -p android && echo "sdk.dir=${ANDROID_SDK_ROOT}" > android/local.properties
