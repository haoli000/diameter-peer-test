# Use Ubuntu as the base image
FROM ubuntu:22.04

# Install required dependencies and freeDiameter
RUN apt-get update && \
    apt-get install -y freediameter openssl

# Create directory for configuration files
RUN mkdir -p /conf

RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert.pem -keyout /etc/freeDiameter/privkey.pem \
    -subj /CN=peer1.localdomain
RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert2.pem -keyout /etc/freeDiameter/privkey2.pem \
    -subj /CN=peer2.localdomain
RUN openssl dhparam -out /etc/freeDiameter/dh.pem 1024

# Copy configuration files to the image
COPY conf/freeDiameter1.conf /conf/
COPY conf/freeDiameter2.conf /conf/
COPY conf/freeDiameter3.conf /conf/

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
