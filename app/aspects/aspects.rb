# We have three options. To send message before method execution, after
# method execution and around(before and after).

# AroundAspect sends two messages:
# before_message is sent before method execution
# after_message is sent after method execution
# In after_message of around aspect we have access to result of method execution,
# as well as to any object variable(@first_value)
# In before_message we can run any class name instance method

WaterDrop::Aspects::AroundAspect.apply(
  Calculator,
  method: :sum,
  topic: 'karafka_topic_aspect',
  before_message: proc { change_value(rand(5..35)) },
  after_message: ->(result) { result }
)

# Once you need to have only before or only after aspect
# you can use one of the methods below instead

# WaterDrop::Aspects::BeforeAspect.apply(
#     Calculator,
#     method: :sum,
#     topic: 'karafka_topic_aspect',
#     message: proc { change_value(rand(5..35)) }
# )
#

# WaterDrop::Aspects::AfterAspect.apply(
#   Calculator,
#   method: :sum,
#   topic: 'karafka_topic_aspect',
#   message: ->(result) { result }
# )

# Messages which are sent in aspect way also contain additional information:
# method name which was run, arguments of this method, topic name.
