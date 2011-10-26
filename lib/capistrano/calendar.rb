require 'capistrano/calendar/version'

module Capistrano
  module Calendar
    autoload :Client,         'capistrano/calendar/client'
    autoload :Configuration,  'capistrano/calendar/configuration'
    autoload :Runner,         'capistrano/calendar/runner'
  end
end
