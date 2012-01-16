require 'capistrano/calendar'

Capistrano::Configuration.instance.load do

  set(:calendar_runner) do
    {
      :roles => :app,
      :once  => true
    }
  end

  set :try_bundle, fetch(:bundle_cmd, nil) ? "#{ fetch(:bundle_cmd) } exec " : ''

  namespace :calendar do
    desc "Create calendar event"
    task :create_event do
      configuration = Capistrano::Calendar::Configuration.collect(self)
      string = Capistrano::Calendar::Configuration.encode(configuration)

      run("#{ try_bundle } capistrano-calendar _#{ Capistrano::Calendar::VERSION }_ create_event #{ string }", calendar_runner)
    end

  end
end
