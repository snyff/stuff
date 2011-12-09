#!/usr/bin/env ruby

require 'rubygems'
require 'eventmachine'
require 'amqp'
require 'pp'

class IRCBot < EM::Connection
  include EventMachine::Protocols::LineText2

  def initialize(queue)
    @queue = queue
    @channel = "bot"
    EM.add_timer(1){ pop }
  end

  def pop
    @queue.pop { |msg|
      say msg if msg
      EM.add_timer(1){ pop }   
    }
  end

  def say(msg)
    msg.split("\n").each do |msg|
      next if msg =~ /^\//
      command( "PRIVMSG ##{@channel } :#{ msg }")
    end
  end
 
  def post_init
    puts "connected"
    command "USER", ["bot"]*4
    command "NICK", "[X]"
    command("JOIN", "##{ @channel }")  
  end


  def receive_line(line)
    puts "received #{line}"
    case line
      when /^PING (.*)/ 
        command('PONG', $1)
      else 
    end
  end

  def command(*cmd)
    send_data "#{ cmd.flatten.join(' ') }\r\n"
  end


end

EM.run do
  queue = MQ.queue('bot')
  EM.connect('localhost', 6667, IRCBot, queue)
end


