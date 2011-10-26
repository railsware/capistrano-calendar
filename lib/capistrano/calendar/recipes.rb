require 'capistrano/calendar'

Capistrano::Configuration.instance.load do

  set(:calendar_runner) do
    {
      :roles => :app,
      :once  => true
    }
  end

  namespace :calendar do
    desc "Create calendar event"
    task :create_event do
      configuration = Capistrano::Calendar::Configuration.collect(self)
      string = Capistrano::Calendar::Configuration.encode(configuration)

      run("capistrano-calendar _#{Capistrano::Calendar::VERSION}_ create_event #{string}", calendar_runner)
    end

  end
end
