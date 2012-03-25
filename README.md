# Capistrano Calendar

## Introduction

capistrano-calendar is extension for capistrano that allows your create different deployment notification in calendar service. Currently supported services:

* google calendar

## Installation

    gem install capistrano-calendar

Add to your Capfile

    require 'capistrano/calendar/recipes'

## How it works

This gem provides:

* capistrano recipe *calendar:create_event* 
* ruby binary script *capistrano-calendar*

Capistrano recipe should be used in some :after hooks (e.g. after deploy). Recipe reads calendar configurations and run capistrano-calendar binary on some host specified in *capistrano_runner* option. So you **need to install** *capistrano-calendar* gem also on that calendar host. Also please ensure that you properly configured calendar_runner otherwise you may have **duplicated events** in calender.

## Calendar configuration

* *:calendar_verbose (nil) - if true display calendar data actions
* *:calendar_logfile (/tmp/capistrano-calendar-PID.log) - calendar log
* *:calendar_foreground (nil) -  don't daemonize calendar process if true
* *:calendar_service* (:google) - calendar service to use e.g. ':google'
* **:calendar_username** (nil) - calendar service username e.g 'vasya.pupkin@gmail.com'
* **:calendar_password** (nil) - calendar service password e.g 'qwery123456'
* *:calendar_name* (default) - calendar name to use for events
* *:calendar_summary* (nil) - calendar summary for new calendar
* *:calendar_location* (nil) - calendar location for new calendar
* *:calendar_timezone* ('UTC') - calendar timezone for new calendar
* *:calendar_color* ('#A32929') - calendar color for new calendar
* **:calendar_event_name** (nil) - calendar event name
* *:calendar_event_summary* (nil) - calendar event summary
* *:calendar_event_location* (nil) - calendar event location
* *:calendar_event_time* (Time.now) - calendar event time
* *:calendar_event_status* ('confirmed') - calendar event status

Bold means required options. Value in brackets means default value.

## Calendar runner configuration

Calendar event creation will be executed by default on the one of application servers (specified in :app roles)
You can change this behavior via *calendar_runner* option. Examples:

    set(:calendar_runner, { :roles => :calendar_notifier, :once => true })
    # or
    set(:calendar_runner, { :hosts => 'notification.example.com' })

Be sure to pass `:once => true` option if you use *:roles* !

## Configuration example

    set :calendar_service, :google
    set :calendar_username, 'vasya.pupkin@my.company.com'
    set :calendar_password, '123456'

    set(:calendar_name)      { stage }
    set(:calendar_summary)   { "" }
    set :calendar_timezone, 'UTC'
    set(:calendar_color),    { stage == 'production' ? '#ff000' : '#00ff00' }

    set(:calendar_event_summary) { "Bla" }
    set(:calendar_event_time) { Time.now }

    after 'deploy' do
      set :calendar_event_name, "[Deployed] #{application} #{branch}: #{real_revision}"
      top.calendar.create_event
    end

    after 'deploy:rollback' do
      set :calendar_event_name, "[Rollback] #{application} #{branch}: #{real_revision}"
      top.calendar.create_event
    end

    #
    # Extra configurations if you are using capistrano-patch:
    #
    after 'patch:apply' do
      set :calendar_event_name, "[Pathed] #{application} #{branch}: #{patch_strategy.revision_to}"
      calendar_client.create_event
    end

    after 'patch:revert' do
      set :calendar_event_name, "[Patch rollback] #{application} #{branch}: #{patch_strategy.revision_from}"
      top.calendar.create_event
    end

