# syntax = docker/dockerfile:1

# Base image with shared configurations
FROM --platform=linux/amd64 ruby:3.2.2-slim AS base
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config

# Builder stage for gems and assets
FROM --platform=linux/amd64 ruby:3.2.2-slim AS builder
WORKDIR /rails

# Install gems
COPY Gemfile Gemfile.lock ./
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential && \
    bundle install && \
    rm -rf ~/.bundle/ /usr/local/bundle/ruby/*/cache /usr/local/bundle/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .
RUN bundle exec bootsnap precompile --gemfile

# Final stage
FROM --platform=linux/amd64 ruby:3.2.2-slim
WORKDIR /rails

# Copy built artifacts
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /rails /rails

# Add user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Configure the main process to run when running the image
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
