# Karafka example application

[![Build Status](https://travis-ci.org/karafka/karafka-example-app.png)](https://travis-ci.org/karafka/karafka-example-app)
[![Join the chat at https://gitter.im/karafka/karafka](https://badges.gitter.im/karafka/karafka.svg)](https://gitter.im/karafka/karafka?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is an example application which uses [Karafka framework](https://github.com/karafka/karafka
) to receive messages from [Apache Kafka](http://kafka.apache.org/) server, [WaterDrop gem](https://github.com/karafka/waterdrop) to send messages to Kafka server and (for some topics) [Karafka Sidekiq Backend](https://github.com/karafka/karafka-sidekiq-backend) to process them in Sidekiq.

**Note**: Sidekiq usage in Karafka is optional and it is not a default. To use it, you need to use [Karafka Sidekiq Backend](https://github.com/karafka/karafka-sidekiq-backend). It is added here just as an example of possibility to process things in it automatically.

To run this application locally you should run Apache Kafka on those hosts and ports which are set in *app.rb* file.

## Usage

Following commands are available. You should run them in the console.

Run sidekiq worker to manage messages background processing (only when using Karafka Sidekiq Backend that is optional):
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
* [Karafka example application Travis CI](https://travis-ci.org/karafka/karafka-example-app)
* [Karafka example application Coditsu](https://app.coditsu.io/karafka/repositories/karafka-example-app)

## Note on Patches/Pull Requests

Fork the project.
Make your feature addition or bug fix.
Add tests for it. This is important so we don't break it in a future versions unintentionally.
Commit, do not mess with Rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull). Send me a pull request. Bonus points for topic branches.

[![coditsu](https://coditsu.io/assets/quality_bar.svg)](https://app.coditsu.io/karafka/repositories/karafka-example-app)

Each pull request must pass our quality requirements. To check if everything is as it should be, we use [Coditsu](https://coditsu.io) that combinse multiple linters and code analyzers for both code and documentation.

Unfortunately, it does not yet support independent forks, however you should be fine by looking at what we require.

Please run:

```bash
bundle exec rake
```

to check if everything is in order. After that you can submit a pull request.
