# syntax = docker/dockerfile:1

# Base image with shared configurations
FROM ruby:3.2.2-slim

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs npm sqlite3 libsqlite3-dev

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Install JS dependencies
COPY package.json yarn.lock ./
RUN npm install -g yarn && yarn install

# Copy application code
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Add environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV PORT=8080

# Initialize database
RUN bundle exec rails db:create db:migrate

# Start the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080"]

# Health check
EXPOSE 8080
HEALTHCHECK CMD curl --fail http://localhost:8080/ || exit 1
