# Karafka example application

[![Build Status](https://github.com/karafka/example-app/actions/workflows/ci.yml/badge.svg)](https://github.com/karafka/example-app/actions/workflows/ci.yml)
[![Join the chat at https://slack.karafka.io](https://raw.githubusercontent.com/karafka/misc/master/slack.svg)](https://slack.karafka.io)

This is an example application which uses [Karafka framework](https://github.com/karafka/karafka
) to receive messages from [Apache Kafka](http://kafka.apache.org/) server, [WaterDrop gem](https://github.com/karafka/waterdrop) to send messages to Kafka server and (for some topics) [Karafka Sidekiq Backend](https://github.com/karafka/karafka-sidekiq-backend) (optional) to process them in Sidekiq.

**Note**: Sidekiq usage in Karafka is optional and it is not a default. To use it, you need to use Karafka Sidekiq Backend. It is added here just as an example of possibility to process things in it automatically.

To run this application locally you should run Apache Kafka on those hosts and ports which are set in ```karafka.rb``` file.

## Usage

Following commands are available. You should run them in the console.

Run Sidekiq worker to manage messages background processing (only when using Karafka Sidekiq Backend that is optional). You will need to install [Redis](https://github.com/antirez/redis) and run it before running the worker:
```
  bundle exec karafka worker
```
Run Karafka server to consume messages, schedule and/or process them:
```
  bundle exec karafka s
```

Generate messages to Kafka server by sending them using WaterDrop:
```
  bundle exec rake waterdrop:send
```

## References

* [Karafka framework](https://github.com/karafka/karafka)
* [Karafka example application Actions CI](https://github.com/karafka/example-app/actions?query=workflow%3Aci)
* [Karafka example application Coditsu](https://app.coditsu.io/karafka/repositories/example-app)

## Note on contributions

First, thank you for considering contributing to the Karafka ecosystem! It's people like you that make the open source community such a great community!

Each pull request must pass all the RSpec specs, integration tests and meet our quality requirements.

Fork it, update and wait for the Github Actions results.
