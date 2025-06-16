# Karafka 2.4 non Rails example application

This is an example application which uses:

- [Karafka framework](https://github.com/karafka/karafka) `2.4` to receive messages from [Apache Kafka](http://kafka.apache.org/) server
- [WaterDrop gem](https://github.com/karafka/waterdrop) to send messages back to Kafka
- [Karafka-Testing](https://github.com/karafka/testing) provides RSpec helpers, to make testing of Karafka consumers much easier

## Usage

Please run `bundle install` to install all the dependencies.

After that, following commands are available. You should run them in the console.

Create all needed topics:

```
bundle exec karafka topics migrate
```

Run Karafka server to consume messages, process and send messages:

```
bundle exec karafka s
```

Generate initial messages to Kafka server by sending them using WaterDrop:

```
bundle exec rake waterdrop:send
```

You can also run RSpec specs to see how the testing RSpec library integrates with RSpec:

```
bundle exec rspec spec
```
