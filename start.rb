#!/usr/local/bin/ruby
require 'rubygems'
require 'highline/import'
require 'treetop'

dir = File.dirname(__FILE__)
Treetop.load File.expand_path(dir + '/dutch_recurring_events.tt')

parser = DutchRecurringEventsParser.new

say("<%= color('DUTCH RECURRING EVENTS', GREEN) %>")

quit_keywords = ["quit","exit","q"]
reload_keywords = ["reload","refresh","r"]
sentence = ""

while !quit_keywords.include?(sentence)
  sentence = ask("Enter sentence to parse:", String) { |s| s.case = :down ; s.readline = true }  
  
  if quit_keywords.include?(sentence)
    break
  elsif reload_keywords.include?(sentence)
    Treetop.load File.expand_path(dir + '/dutch_recurring_events.tt')
    parser = DutchRecurringEventsParser.new
    say("[reloaded]")
  else
  
    begin
      syntax_nodes = parser.parse(sentence)
      
      if syntax_nodes  
        p syntax_nodes.evaluate
        puts ""
      else
        say("[unparsable]")
      end
    rescue Exception => e
      say "[exception] #{e}"
    end

  end
  
end