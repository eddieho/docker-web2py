# Use an official Apache httpd runtime as a parent image
FROM httpd:2.4

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed OS packages
# need to call 'apt-get update' first or it can't find package name
#
RUN apt-get update; apt-get install -y dnsutils net-tools vim zip

# Make port 80 available to the world outside this container
EXPOSE 80

