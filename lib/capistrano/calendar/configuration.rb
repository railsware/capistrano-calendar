require 'yaml'
require 'base64'

module Capistrano
  module Calendar
    class Configuration

      def self.collect(hash)
        [
          :calendar_logfile,
          :calendar_foreground,

          :calendar_service,
          :calendar_username,
          :calendar_password,

          :calendar_name,
          :calendar_summary,
          :calendar_location,
          :calendar_timezone,
          :calendar_color,

          :calendar_event_name,
          :calendar_event_summary,
          :calendar_event_location,
          :calendar_event_time,
          :calendar_event_status
        ].inject({}) { |result, key|
          result[key] = hash[key] if hash.exists?(key)
          result
        }
      end

      def self.encode(hash)
        Base64.encode64(hash.to_yaml).gsub("\n", '')
      end

      def self.decode(string)
        YAML.load(Base64.decode64(string))
      end

    end
  end
end
