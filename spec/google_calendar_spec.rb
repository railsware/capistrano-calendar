require 'spec_helper'

describe Capistrano::Calendar::Client, "#create_event for google calendar" do

  let(:configuration) do
    {
      :calendar_service    => :google,
      :calendar_username   => Helper.credentials[:google][:username],
      :calendar_password   => Helper.credentials[:google][:password],
      :calendar_name       => "Capistrano Calendar",
      :calendar_event_name => 'Test Deploy!'
    }
  end

  let(:client) {
    client = Capistrano::Calendar::Client.new(configuration)
    client.authenticate
    client
  }

  before(:each) do
    sleep(1)
    configuration[:calendar_name] << " #{Time.now.to_f}"
  end

  it "should create calendar and event" do
    event = client.create_event

    event.should be_kind_of(Hash)
    event['title'].should == configuration[:calendar_event_name]

    calendar = client.find_calendar(configuration[:calendar_name])
    calendar.should be_kind_of(Hash)
    calendar['title'].should == configuration[:calendar_name]
    calendar['timeZone'].should == 'UTC'
  end

  context "when calendar exists" do
    before(:each) do
      @calendar = client.create_calendar(configuration[:calendar_name])
    end

    it "should create event and does NOT create another calendar" do
      event = client.create_event

      event.should be_kind_of(Hash)
      event['title'].should == configuration[:calendar_event_name]

      calendar = client.find_calendar(configuration[:calendar_name])
      calendar.should be_kind_of(Hash)
      calendar['id'].should == @calendar['id']
    end
  end

  context "when calendar_name is nil" do
    before(:each) do
      configuration.delete(:calendar_name)
    end

    it "should create event in default calendar" do
      event = client.create_event

      event.should be_kind_of(Hash)
      event['title'].should == configuration[:calendar_event_name]
      event['selfLink'].should include(Capistrano::Calendar::Client::Google::CALENDAR_EVENTS_URL)
    end
  end
end
