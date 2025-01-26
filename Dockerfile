# syntax = docker/dockerfile:1

# Base image with shared configurations
FROM ruby:3.2.2-slim

# Install minimal dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libsqlite3-dev curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy application code
COPY . .

# Add environment variables
ENV RAILS_ENV=production
ENV PORT=3000

# Precompile bootsnap
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Add health check endpoint
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Start the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
