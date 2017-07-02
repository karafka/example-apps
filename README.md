# Karafka example application

[![Build Status](https://travis-ci.org/karafka/karafka-example-app.png)](https://travis-ci.org/karafka/karafka-example-app)
[![Code Climate](https://codeclimate.com/github/karafka/karafka-example-app/badges/gpa.svg)](https://codeclimate.com/github/karafka/karafka-example-app)
[![Join the chat at https://gitter.im/karafka/karafka](https://badges.gitter.im/karafka/karafka.svg)](https://gitter.im/karafka/karafka?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is an example application which uses [Karafka framework](https://github.com/karafka/karafka
) to receive messages from [Apache Kafka](http://kafka.apache.org/) server and [WaterDrop gem](https://github.com/karafka/waterdrop) to send messages to Kafka server.

To run this application locally you should run Apache Kafka and Apache ZooKeeper servers on those hosts and ports which
are set in *app.rb* and */config/initializers/water_drop.rb* files.

## Usage

Following available. You should run them in the console.

#### Run sidekiq worker to manage perform methods of controllers
```
  bundle exec karafka worker
```
#### Run Kafka consumer. It will receive messages and send them to needed controller based on it's topic name
```
  bundle exec karafka s
```

#### Generate messages to Kafka server by sending message directly

```
  bundle exec rake waterdrop:send
```

## References

* [Karafka framework](https://github.com/karafka/karafka)
* [Waterdrop](https://github.com/karafka/waterdrop)
* [Worker Glass](https://github.com/karafka/worker-glass)
* [Envlogic](https://github.com/karafka/envlogic)
* [Null Logger](https://github.com/karafka/null-logger)
* [Apache Kafka](http://kafka.apache.org/)
* [Apache ZooKeeper](https://zookeeper.apache.org/)
* [Karafka example application Travis CI](https://travis-ci.org/karafka/karafka-example-app)
* [Karafka example application Code Climate](https://codeclimate.com/github/karafka/karafka-example-app)

## Note on Patches/Pull Requests

Fork the project.
Make your feature addition or bug fix.
Add tests for it. This is important so I don't break it in a future version unintentionally.
Commit, do not mess with Rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull). Send me a pull request. Bonus points for topic branches.

[![coditsu](https://coditsu.io/assets/quality_bar.svg)](https://coditsu.io)

Each pull request must pass our quality requirements. To check if everything is as it should be, we use [Coditsu](https://coditsu.io) that combinse multiple linters and code analyzers. Unfortunately, for now it is invite-only based, so just ping us and we will give you access to the quality results.

```bash
bundle exec rake
```

to check if everything is in order. After that you can submit a pull request.
