# Karafka 2.5 non Rails example application

This is an example application which uses:

- [Karafka framework](https://github.com/karafka/karafka) `2.5` to receive messages from [Apache Kafka](http://kafka.apache.org/) server
- [Karafka Web UI](https://github.com/karafka/karafka-web) for Karafka processes management
- [WaterDrop gem](https://github.com/karafka/waterdrop) to send messages back to Kafka
- [Karafka-Testing](https://github.com/karafka/testing) provides RSpec helpers, to make testing of Karafka consumers much easier

## Usage

1. Start Kafka using our `docker-compose.yml` by running: `docker-compose up`
2. Run our setup script `./bin/bootstrap` - it will install dependencies, needed topics, etc.
3. Run `bundle exec karafka server` to start Karafka consumption server
4. Run `bundle exec puma config.ru` to start the Karafka Web UI server
5. Visit `localhost:9292` to see and explore the Karafka Web UI

Generate initial messages to Kafka server by sending them using WaterDrop:

```
bundle exec rake waterdrop:send
```

You can also run RSpec specs to see how the testing RSpec library integrates with RSpec:

```
bundle exec rspec spec
```
