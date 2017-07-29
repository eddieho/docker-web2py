# Use an official Python runtime as a parent image
FROM python:2.7

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed OS packages
# need to call 'apt-get update' first or it can't find package name
#
RUN apt-get update; apt-get install -y dnsutils net-tools vim mysql-client

# Install any needed packages specified in requirements.txt
RUN pip install -r pip_requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
