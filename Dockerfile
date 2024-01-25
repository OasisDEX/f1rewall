FROM python:3.8-slim

# Set environment variables for application configuration
ENV RECAPTCHA_PUBLIC=$RECAPTCHA_PUBLIC \
    RECAPTCHA_PRIVATE=$RECAPTCHA_PRIVATE \
    DISCORD_WELCOME_ROOM=$DISCORD_WELCOME_ROOM \
    DISCORD_PRIVATE=$DISCORD_PRIVATE \
    PORT=$PORT \
    PYTHONUNBUFFERED=1

# Create a system group named "docker"
RUN groupadd -r docker

# Create a system user named "docker"
RUN useradd -m -r -g docker docker

# Set the working directory
WORKDIR /app

# Change the ownership of the working directory to the non-root user "docker"
RUN chown -R docker:docker /app

# Switch to the "docker" user
USER docker

# Copy the necessary files
COPY etc ./etc
COPY static ./static
COPY templates ./templates
COPY app.py ./app.py
COPY requirements.txt ./requirements.txt
COPY server.py ./server.py

# Install the required dependencies
RUN python -m pip install --user -r requirements.txt

# Set the command to run the server
CMD ["python", "./server.py"]
