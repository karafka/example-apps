# Karafka example application

[![Build Status](https://travis-ci.org/karafka/example-app.png)](https://travis-ci.org/karafka/example-app)
[![Join the chat at https://gitter.im/karafka/karafka](https://badges.gitter.im/karafka/karafka.svg)](https://gitter.im/karafka/karafka?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is an example application which uses [Karafka framework](https://github.com/karafka/karafka
) to receive messages from [Apache Kafka](http://kafka.apache.org/) server, [WaterDrop gem](https://github.com/karafka/waterdrop) to send messages to Kafka server and (for some topics) [Karafka Sidekiq Backend](https://github.com/karafka/karafka-sidekiq-backend) (optional) to process them in Sidekiq.

**Note**: Sidekiq usage in Karafka is optional and it is not a default. To use it, you need to use Karafka Sidekiq Backend. It is added here just as an example of possibility to process things in it automatically.

To run this application locally you should run Apache Kafka on those hosts and ports which are set in ```karafka.rb``` file.

## Usage

Following commands are available. You should run them in the console.

Run Sidekiq worker to manage messages background processing (only when using Karafka Sidekiq Backend that is optional). You will need to install [Redis](https://github.com/antirez/redis) and run it before running the worker:
```
  redis-server
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
* [Karafka example application Travis CI](https://travis-ci.org/karafka/karafka-example-app)
* [Karafka example application Coditsu](https://app.coditsu.io/karafka/repositories/karafka-example-app)

## Note on contributions

First, thank you for considering contributing to Karafka! It's people like you that make the open source community such a great community!

Each pull request must pass all the RSpec specs and meet our quality requirements.

To check if everything is as it should be, we use [Coditsu](https://coditsu.io) that combines multiple linters and code analyzers for both code and documentation. Once you're done with your changes, submit a pull request.

Coditsu will automatically check your work against our quality standards. You can find your commit check results on the [builds page](https://app.coditsu.io/karafka/repositories/karafka-example-app/builds/commit_builds) of Karafka example app repository.

[![coditsu](https://coditsu.io/assets/quality_bar.svg)](https://app.coditsu.io/karafka/repositories/karafka-example-app/builds/commit_builds)
