namespace :waterdrop do
  desc 'Generates messages to Kafka server'
  task :send do
    Generator.new.send_messages
  end
end
