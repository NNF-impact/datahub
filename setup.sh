#!/bin/bash

# Update package list
sudo apt-get update

# Install Kerberos-related packages
sudo debconf-set-selections <<< "krb5-config krb5-config/default_realm string YOUR.REALM"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-user krb5-config libkrb5-dev

# Install LDAP-related packages
sudo apt-get install -y libldap2-dev libsasl2-dev

# Install OpenJDK 8 and OpenJDK 11
sudo apt-get install -y openjdk-8-jdk openjdk-11-jdk

# Set up alternatives to manage multiple Java versions
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/bin/java 1
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-11-openjdk-amd64/bin/java 2

# Set default Java version (change to the version you need as default)
sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java

# Verify Java installation
java -version

# Install Python dependencies if there is a requirements.txt
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

# Install Gradle dependencies
./gradlew build --refresh-dependencies

# Build Docker containers if there is a docker-compose file
if [ -f "docker-compose.yml" ]; then
    docker-compose up --build
fi
