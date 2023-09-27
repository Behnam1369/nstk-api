# Use an official Ruby runtime as a parent image
FROM ruby:3.1.2

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs freetds-dev

# Install Bundler
RUN gem install bundler

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems using bundler
RUN bundle install

# Copy the rest of your application code into the container
COPY . .

# Expose port 3000 for the Rails application
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
