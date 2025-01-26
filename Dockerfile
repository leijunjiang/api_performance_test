# syntax = docker/dockerfile:1

# Base image with shared configurations
FROM ruby:3.2.2-slim

# Install minimal dependencies for Rails API
RUN apt-get update -qq && \
    apt-get install -y build-essential libsqlite3-dev

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Add environment variables
ENV RAILS_ENV=production
ENV PORT=8080

# Initialize database
RUN bundle exec rails db:create db:migrate

# Start the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080"]

# Health check
EXPOSE 8080
HEALTHCHECK CMD curl --fail http://localhost:8080/health || exit 1
