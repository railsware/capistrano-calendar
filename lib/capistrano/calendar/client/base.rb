module Capistrano
  module Calendar
    module Client
      class Base
        def initialize(config)
          @configuration = config
        end

        attr_reader :configuration

        def calendar_username
          configuration.fetch(:calendar_username)
        end

        def calendar_password
          configuration.fetch(:calendar_password)
        end

        def authenticate
          raise NotImplementedError, "`authenticate' is not implemented by #{self.class.name}"
        end

        def create_event
          raise NotImplementedError, "`create_event' is not implemented by #{self.class.name}"
        end

      end

    end
  end
end
