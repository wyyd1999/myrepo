# Dockerfile for Hello World program

FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y gcc

# Copy the source code
COPY . /usr/src/myapp

# Set the working directory
WORKDIR /usr/src/myapp

# Compile the program
RUN gcc -o hello_world hello_world.c

# Run the program
CMD ["./hello_world"]

