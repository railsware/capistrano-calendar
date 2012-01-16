require 'spec_helper'

describe Capistrano::Calendar::Client do

  it { lambda { Capistrano::Calendar::Client.new(mock('config', :[] => nil)) }.should_not raise_exception }

end
