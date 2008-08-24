dir = File.dirname(__FILE__)

require 'rubygems'
require File.expand_path(dir + '/../../lib/treetop')
require 'spec'

require File.expand_path(dir + '/../nodes.rb')
Treetop.load File.expand_path(dir + '/../dutch_recurring_events.tt')