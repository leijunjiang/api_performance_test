# syntax = docker/dockerfile:1

# Base image with shared configurations
FROM ruby:3.2.2-slim

# Install minimal dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libsqlite3-dev curl procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy application code
COPY . .

# Add startup script
COPY <<-"EOF" /start.sh
#!/bin/bash
set -e

# Remove any existing pid file
rm -f /app/tmp/pids/server.pid

echo "=== Starting Rails Server on port 8080 ==="
exec bundle exec rails server -p 8080 -b 0.0.0.0
EOF

RUN chmod +x /start.sh

# Environment variables
ENV RAILS_ENV=production
ENV PORT=8080
ENV RAILS_LOG_TO_STDOUT=true

CMD ["/start.sh"]
