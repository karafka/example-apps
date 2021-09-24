# Karafka 1.4 non Rails example application

This is an example application which uses:

- [Karafka framework](https://github.com/karafka/karafka
) `1.4` to receive messages from [Apache Kafka](http://kafka.apache.org/) server
- [WaterDrop](https://github.com/karafka/waterdrop) to send messages to Kafka server
- [Karafka-Testing](https://github.com/karafka/testing) provides RSpec helpers, to make testing of Karafka consumers much easier
- (for some topics) [Karafka Sidekiq Backend](https://github.com/karafka/karafka-sidekiq-backend) (optional) to process them in Sidekiq

**Note**: Sidekiq usage in Karafka `1.4` is optional and it is not a default. To use it, you need to use Karafka Sidekiq Backend. It is added here just as an example of possibility to process things in it automatically.

## Usage

Please run `bundle install` to install all the dependencies.

After that, following commands are available. You should run them in the console.

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

You can also run RSpec specs to see how the testing RSpec library integrates with RSpec:

```
bundle exec rspec spec
```
