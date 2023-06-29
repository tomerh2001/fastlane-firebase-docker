# Stage 1: Use JDK 8 for Android SDK
FROM adoptopenjdk:8-jdk-hotspot AS builder

# Set Java environment
ENV JAVA_HOME /opt/java/openjdk
ENV PATH $JAVA_HOME/bin:$PATH

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    unzip \
    git \
    python3 \
    python3-pip

# Install the Android SDK
ENV ANDROID_SDK_ROOT /opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT} && cd ${ANDROID_SDK_ROOT} && \
    curl -o sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip sdk-tools.zip && \
    rm sdk-tools.zip

# Accept licenses
RUN yes | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --licenses

# Update and install using sdkmanager
RUN ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager "platform-tools" "platforms;android-31" "build-tools;30.0.2"

# Stage 2: Use Ruby 2.7 for the final image
FROM ruby:2.7

# Copy Java and Android SDK from builder image
COPY --from=builder /opt/java/openjdk /opt/java/openjdk
COPY --from=builder /opt/android-sdk $ANDROID_SDK_ROOT

# Update PATH for Java and Android SDK
ENV PATH $PATH:/opt/java/openjdk/bin:${ANDROID_SDK_ROOT}/platform-tools/

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Install yarn
RUN npm install -g yarn

# Verify Node.js, npm, and yarn install
RUN node -v
RUN npm -v
RUN yarn -v

# Install fastlane
RUN gem install fastlane -NV

# Install Firebase CLI
RUN npm install -g firebase-tools

# Clean up
RUN apt-get clean

# Create app directory
WORKDIR /usr/src/app
