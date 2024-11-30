FROM registry.access.redhat.com/ubi9/ubi:latest

# Install EPEL and dependencies
RUN dnf update -y && dnf clean all
RUN dnf install -y inkscape fontconfig && dnf clean all
RUN dnf install -y redhat-display-fonts redhat-text-fonts overpass-fonts && dnf clean all
RUN fc-cache -fv && fc-list | grep "Red Hat\|Overpass"
RUN dnf install -y python3 python3-pip python3-jinja2 && dnf clean all
RUN pip install flask pyyaml 
RUN pip install jinja2-cli

# Copy the Flask app to the container
WORKDIR /app

COPY app.py .
RUN mkdir /app/static
RUN mkdir /app/templates
COPY default.yaml .
COPY letter.svg.j2 .
COPY slide.svg.j2 .
COPY static/layers.ico /app/static/layers.ico
COPY static/layers.png /app/static/layers.png
COPY static/styles.css /app/static/styles.css
COPY templates/index.html /app/templates/index.html

# Expose the Flask app's port
EXPOSE 5050

# Command to run the Flask app
CMD ["python3", "app.py"]
