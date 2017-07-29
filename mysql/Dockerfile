# Use an official MySQL runtime as a parent image
FROM mysql:5.7

# Set the working directory to /db
WORKDIR /db

# Install any needed OS packages
# need to call 'apt-get update' first or it can't find package name
#
RUN apt-get update; apt-get install -y dnsutils net-tools vim

# Make port 3306 available to the world outside this container
EXPOSE 3306

