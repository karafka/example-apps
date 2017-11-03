# frozen_string_literal: true

# Basic Model class
class Calculator
  attr_reader :first_value

  # Method which sum parameters; first parameter is defined. Can be predefined in before aspect
  def sum(*args)
    @first_value ||= 5
    send_message(args: args, message: @first_value)
    args_sum = args.inject(0, :+)
    result = @first_value + args_sum
    send_message(args: args, message: result)
    result
  end

  private

  # Is used to set @first_value before run execution.
  def change_value(num)
    @first_value = num
  end

  # Sends a message to a proper topic
  def send_message(params)
    WaterDrop::SyncProducer.call(params.to_json, topic: 'aspected_messages')
  end
end
