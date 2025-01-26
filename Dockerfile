# syntax = docker/dockerfile:1

# Base image with shared configurations
FROM ruby:3.2.2-slim

# Install minimal dependencies + debugging tools
RUN apt-get update -qq && \
    apt-get install -y build-essential libsqlite3-dev curl vim netcat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Add environment variables
ENV RAILS_ENV=production
ENV PORT=8080
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

# Initialize database and seed
RUN bundle exec rails db:create db:migrate db:seed

# Add debug script
COPY <<-"EOF" /debug.sh
#!/bin/bash
# Start netcat to listen on port 8080
nc -l -p 8080 &
# Keep container running
while true; do
  sleep 1
done
EOF
RUN chmod +x /debug.sh

# Use different command for debug mode
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080"]
