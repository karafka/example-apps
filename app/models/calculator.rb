# Basic Model class
class Calculator
  attr_reader :first_value

  # Method which sum parameters; first parameter is defined. Can be predefined in before aspect
  def sum(*args)
    @first_value ||= 5
    args_sum = args.inject(0, :+)
    @first_value + args_sum
  end

  private

  # Is used to set @first_value before run execution.
  def change_value(num)
    @first_value = num
  end
end
