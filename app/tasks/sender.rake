namespace :waterdrop do
  desc 'Runs a single Karafka processing instance'
  task :send do
    Generator.new.send_messages
  end
end
