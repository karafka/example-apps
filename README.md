# Karafka example applications

[![Build Status](https://github.com/karafka/example-app/actions/workflows/ci.yml/badge.svg)](https://github.com/karafka/example-app/actions/workflows/ci.yml)
[![Join the chat at https://slack.karafka.io](https://raw.githubusercontent.com/karafka/misc/master/slack.svg)](https://slack.karafka.io)

This repository contains  example applications using [Karafka framework](https://github.com/karafka/karafka
) to receive messages from [Apache Kafka](http://kafka.apache.org/) with integrated [WaterDrop gem](https://github.com/karafka/waterdrop) to send messages to Kafka and the [Karafka Web UI](https://github.com/karafka/karafka-web) for Karafka processes management.

To run those applications locally start Apacke Kafka with the included `docker-compose.yml` and follow instructions from the sub-READMEs.

## Applications available

- Karafka `2.1` Ruby on Rails based [application example](https://github.com/karafka/example-apps/tree/master/v2.1-rails)
- Karafka `2.1` non Rails based [application example](https://github.com/karafka/example-apps/tree/master/v2.1-non-rails)

![karafka web ui](https://raw.githubusercontent.com/karafka/misc/master/printscreens/web-ui.png)

## Note on contributions

First, thank you for considering contributing to the Karafka ecosystem! It's people like you that make the open source community such a great community!

Each pull request must pass all the RSpec specs, integration tests and meet our quality requirements.

Fork it, update and wait for the Github Actions results.
