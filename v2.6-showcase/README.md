# Karafka 2.6 showcase application

A Ruby on Rails application that shows most of the Karafka features on one domain: a small shop where an order goes through **payments**, **inventory** and **notifications**.

It uses:

- [Karafka](https://github.com/karafka/karafka) `2.6` to consume messages from [Apache Kafka](https://kafka.apache.org/)
- [WaterDrop](https://github.com/karafka/waterdrop) to produce them, including a transaction
- [Karafka Web UI](https://github.com/karafka/karafka-web) to see what the processes do
- [Karafka-Testing](https://github.com/karafka/karafka-testing) for the consumer specs

This is the OSS layer: everything here runs without a Karafka Pro license. The features marked **Pro** below come with the Pro layer.

## Flow

```
POST /orders ──> orders ──┬─> [payments]  PaymentsConsumer ──> payments ──> [inventory] InventoryConsumer ─┬─> inventory
                          │        │                                                    (one transaction) └─> notifications ──> [notifications] NotificationsConsumer
                          │        └─> payments_dlq (declined cards)
                          └─> [analytics] OrderStatsConsumer

products (compacted) ──> [catalog] ProductsCacheConsumer
```

`[name]` is a consumer group. Orders are keyed by customer, so the orders of one customer keep their order.

## Usage

1. Start Kafka with the `docker-compose.yml` from the repository root: `docker compose up -d`
2. Run `./bin/bootstrap`: it installs the gems, creates the database, the topics and the Web UI topics, and publishes the catalog
3. Run `bundle exec karafka swarm` (or `bundle exec karafka server` for one process)
4. Run `bundle exec rails server`
5. Place orders:

```bash
curl -d 'customer_id=alice&sku=mug&quantity=2' localhost:3000/orders
# The gateway is down for the first attempt of this order: the partition pauses
curl -d 'customer_id=bob&sku=tshirt&card=unavailable' localhost:3000/orders
# The card is declined: two retries, then the order goes to the DLQ
curl -d 'customer_id=carol&sku=sticker&card=declined' localhost:3000/orders
curl localhost:3000/orders
```

6. Open `localhost:3000/karafka` to explore the Web UI

Specs (no Kafka needed):

```bash
bundle exec rails db:test:prepare
bundle exec rspec
```

End-to-end check against a running Kafka (after `./bin/bootstrap`): `./bin/e2e`. It starts the Rails server and `karafka swarm`, places orders over HTTP and waits until each order is paid, reserved and notified, the declined order is in `payments_dlq` and the Web UI answers.

## Features

### Multiple consumer groups

The `payments` and `analytics` groups both read the `orders` topic. Each group has its own offsets and lag: a slow payment gateway does not delay the statistics.

- Code: `karafka.rb` (`consumer_group :payments`, `consumer_group :analytics`)
- Docs: [Routing](https://karafka.io/docs/Consumer-Groups-Routing/#multiple-consumer-groups-mode)

### Declarative topics

All topics, their partitions and settings (retention of `payments_dlq`, compaction of `products`) are declared in code and created with `bundle exec karafka topics migrate`.

- Code: `karafka.rb` (`declaratives.draw`)
- Docs: [Declarative Topics](https://karafka.io/docs/Infrastructure-Declarative-Topics/)

### Dead Letter Queue with retries

A declined card raises an error. Karafka retries the message twice with a pause, then moves it to `payments_dlq` and continues with the next order. The consumer logs the retry attempt (`retrying?`, `attempt`).

With manual offset management the DLQ does not commit the dispatched message by default. `mark_after_dispatch: true` commits it, so a restart or rebalance does not send the same order to the DLQ again.

- Code: `karafka.rb` (`dead_letter_queue`), `app/consumers/payments_consumer.rb`
- Docs: [Dead Letter Queue](https://karafka.io/docs/Consumer-Groups-Dead-Letter-Queue/)

### Manual offset management

`PaymentsConsumer` marks an order as consumed only after the gateway confirms the charge. An order that was not charged is never committed.

- Code: `karafka.rb` (`manual_offset_management true`), `app/consumers/payments_consumer.rb`
- Docs: [Offset management](https://karafka.io/docs/Consumer-Groups-Offset-management/)

### Pause and seek

- **Pause:** when the gateway is unavailable, `PaymentsConsumer` pauses the partition on the current order for 2 seconds and tries again. This is backpressure, not an error: it does not count as a retry.
- **Seek:** start the processes with `REPLAY_FROM=2026-01-01T00:00:00Z` and `OrderStatsConsumer` drops its totals and seeks each partition back to that time to rebuild them.

- Code: `app/consumers/payments_consumer.rb`, `app/consumers/order_stats_consumer.rb`
- Docs: [Pausing, Seeking and Rate-Limiting](https://karafka.io/docs/Consumer-Groups-Pausing-Seeking-and-Rate-Limiting/)

### Producer transactions

`InventoryConsumer` publishes the `inventory` event and the customer notification in one WaterDrop transaction: consumers see both or none. Kafka allows one active producer per `transactional.id`, so each process and each swarm node builds its own transactional producer.

Committing the consumer offset in the same transaction (exactly-once) is a **Pro** feature.

- Code: `app/consumers/inventory_consumer.rb`, `app/services/transactional_producer.rb`
- Docs: [WaterDrop Transactions](https://karafka.io/docs/WaterDrop-Transactions/), [Pro Transactions](https://karafka.io/docs/Pro-Consumer-Groups-Transactions/)

### End of partition (eofed)

`ProductsCacheConsumer` loads the compacted `products` topic into the catalog, keyed by SKU. A message without a payload (tombstone) deletes the product. When it reaches the end of the partition, it logs that the catalog is warm: with the last messages (`eofed?` in `#consume`) or without them (`#eofed`). This needs `enable.partition.eof`, set only for this topic.

- Code: `karafka.rb` (`eofed true`, `kafka('enable.partition.eof': true, inherit: true)`), `app/consumers/products_cache_consumer.rb`
- Docs: [Reaching the end of a partition](https://karafka.io/docs/Basics-Consuming-Messages/#reaching-the-end-of-a-partition-eof)

### Instrumentation

`AppMetricsListener` subscribes to the Karafka notifications bus and logs a line per consumed batch, per message moved to the DLQ and per error, next to the standard `LoggerListener`.

- Code: `app/listeners/app_metrics_listener.rb`, `karafka.rb`
- Docs: [Monitoring and Logging](https://karafka.io/docs/Infrastructure-Monitoring-and-Logging/)

### Web UI

The Web UI is mounted at `/karafka`. Watch the lag of the `payments` group during a gateway pause, the errors of declined cards and the swarm nodes.

- Code: `config/routes.rb`, `karafka.rb` (`Karafka::Web.enable!`)
- Docs: [Web UI](https://karafka.io/docs/Web-UI-Getting-Started/)

### Swarm

`bundle exec karafka swarm` forks two nodes (`config.swarm.nodes`), each with its own consumers, and a supervisor that restarts a node that dies.

- Code: `karafka.rb` (`config.swarm.nodes`)
- Docs: [Swarm / Multi Process](https://karafka.io/docs/Infrastructure-Swarm-Multi-Process/)

### Testing with karafka-testing

Each consumer has a spec that feeds it messages with `karafka.produce` and checks what it produced with `karafka.produced_messages`, without Kafka. The `InventoryConsumer` spec uses a buffered WaterDrop producer to check that the transaction publishes both messages, or none when it aborts.

- Code: `spec/`
- Docs: [Testing](https://karafka.io/docs/Basics-Testing/)

## Pro layer

The Pro layer turns on with a Karafka Pro license and adds, on the same flow:

- **Pro** virtual partitions, long-running jobs, filtering and expiring, delayed topics, scheduled messages, recurring tasks, throttling
- **Pro** exactly-once consumer transactions (offsets committed in the transaction)
- **Pro** Web UI Health, Explorer and commanding
- **Pro** pinning topics to swarm nodes

Pro routes are drawn only when `Karafka.pro?` (`karafka.rb`) and Pro consumers in `app/consumers/pro/` are not loaded without a license (`config/application.rb`), so this app keeps working without one.
