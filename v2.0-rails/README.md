# Karafka 2.0 Ruby on Rails based example application

This is an example application which uses:

- [Karafka framework](https://github.com/karafka/karafka) `2.0` to receive messages from [Apache Kafka](http://kafka.apache.org/) server
- [Karafka Web UI](https://github.com/karafka/karafka-web) for Karafka processes management
- [Karafka-Testing](https://github.com/karafka/testing) provides RSpec helpers, to make testing of Karafka consumers much easier
- [Ruby on Rails ActiveJob](https://edgeguides.rubyonrails.org/active_job_basics.html) to create user instance in the background 

It allows you to see how Karafka integrates with Ruby on Rails. Each time you visit `localhost:3000` an event will be dispatched to Kafka. This event will be then consumed and stored using Karafka consumer.

This app also includes `ActiveJob` job that creates a visitor instance via ActiveJob by using Karafka backend as well as the Karafka Web UI interface.

Note, that the consumer elevates the `#insert_all` from ActiveRecord to insert data efficiently.

## Usage

1. Start Kafka using our `docker-compose.yml` by running: `docker-compose up`
2. Run our setup script `./bin/bootstrap` - it will install dependencies, setup sqlite, needed topics, etc.
3. Run `bundle exec rails server` to start the Rails web server
4. Run `bundle exec karafka server` to start Karafka consumption server
5. Visit `localhost:3000` and refresh the page couple of times
6. Visit `localhost:3000/karafka` to see and explore the Karafka Web UI

You can also run RSpec specs to see how the testing RSpec library integrates with Rails:

```
bundle exec rspec spec
```
