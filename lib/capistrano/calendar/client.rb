require 'capistrano/errors'

module Capistrano
  module Calendar
    module Client
      def self.new(config)
        name = config[:calendar_service] || :google

        require "capistrano/calendar/client/#{name}"

        client_const = name.to_s.capitalize.gsub(/_(.)/) { $1.upcase }

        const_get(client_const).new(config)

      rescue LoadError
        raise Capistrano::Error, "could not find any client named '#{name}'"
      end
    end
  end
end
