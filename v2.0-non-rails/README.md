# Karafka 2.0 non Rails example application

This is an example application which uses [Karafka framework](https://github.com/karafka/karafka
) `2.0` to receive messages from [Apache Kafka](http://kafka.apache.org/) server and automatically integrated [WaterDrop gem](https://github.com/karafka/waterdrop) to send messages back to Kafka.

## Usage

Please run `bundle install` to install all the dependencies.

After that, following commands are available. You should run them in the console.

Run Karafka server to consume messages, process and send messages:

```
  bundle exec karafka s
```

Generate initial messages to Kafka server by sending them using WaterDrop:

```
  bundle exec rake waterdrop:send
```
