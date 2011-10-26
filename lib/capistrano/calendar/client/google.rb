require 'capistrano/calendar/client/base'

require 'gdata'
require 'json'
require 'time'

module Capistrano
  module Calendar
    module Client
      class Google < Base

        #
        # http://code.google.com/apis/calendar/data/2.0/developers_guide_protocol.html
        #

        OWN_CALENDARS_URL   = "https://www.google.com/calendar/feeds/default/owncalendars/full"
        CALENDAR_EVENTS_URL = "https://www.google.com/calendar/feeds/default/private/full"

        def authenticate
          client.clientlogin(calendar_username, calendar_password)
        end

        def create_event
          response = client.post(events_url, json_event_entity)
          JSON.parse(response.body)['data']
        end

        def events_url
          if configuration[:calendar_name]
            calendar = find_or_create_calendar(configuration[:calendar_name])
            calendar['eventFeedLink']
          else
            CALENDAR_EVENTS_URL
          end
        end

        def find_or_create_calendar(calendar_name)
          find_calendar(calendar_name) || create_calendar(calendar_name)
        end

        def find_calendar(calendar_name)
          response = client.get(OWN_CALENDARS_URL + '?alt=jsonc')
          JSON.parse(response.body)['data']['items'].find { |item|
            item['title'] == calendar_name
          }
        end

        def create_calendar(calendar_name)
          response = client.post(OWN_CALENDARS_URL, json_calendar_entity)
          JSON.parse(response.body)['data']
        end

        def delete_calendar(calendar)
          calendar.is_a?(Hash) or calendar = find_calendar(calendar)
          calendar or raise Capistrano::Error, "Calendar #{calendar.inspect} not found"
          client.delete(calendar['selfLink'])
        end

        protected

        def client
          @client ||= GData::Client::Calendar.new({
            :headers => { 'Content-Type' => 'application/json' },
            :source  => 'capistrano-calendar'
          })
        end

        def json_calendar_entity
          data = {
            'title'    => configuration.fetch(:calendar_name),
            'timeZone' => configuration.fetch(:calendar_timezone, 'UTC'),
            'color'    => configuration.fetch(:calendar_color, '#A32929'),
            'hidden'   => false
          }

          value = configuration[:calendar_summary]  and data['details'] = value
          value = configuration[:calendar_location] and data['location'] = value
          
          { 'data' => data }.to_json
        end

        def json_event_entity
          event_time = configuration.fetch(:calendar_event_time, Time.now).utc.xmlschema

          data = {
            'title'    => configuration.fetch(:calendar_event_name),
            'status'   => configuration.fetch(:calendar_event_status, 'confirmed'),
            'when'     => [
              {
                'start' => event_time,
                'stop'  => event_time
              }
            ]
          }

          value = configuration[:calendar_event_summary]  and data['details'] = value
          value = configuration[:calendar_event_location] and data['location'] = value

          { 'data' => data }.to_json
        end

      end
    end
  end
end
