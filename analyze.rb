#!/usr/local/bin/ruby
require 'yaml'
require 'trello'
include Trello
require_relative 'lib/filelock'

#-----------------------------
# Script lock
#-----------------------------
script = Filelock.new
script.lock

#-----------------------------
# Setup Trello
#-----------------------------
config_file = File.dirname(__FILE__) + "/config/config.yml"
configs = YAML.load_file(config_file)

Trello.configure do |config|
  config.developer_public_key = configs['public_key']
  config.member_token = configs['member_token']
end

#-----------------------------
# Setup Board
#-----------------------------
board_id = ""
my_trello = Member.find(configs['trello_account'])
my_trello.boards.each do |board|
  board_id = board.id if board.name == configs['trello_board']
end

#-----------------------------
# Setup List
#-----------------------------
#-----------------
# Time diff method
#-----------------
def time_diff(start_time, end_time)
  seconds_diff = (start_time - end_time).to_i.abs

  days = seconds_diff / 86400
  seconds_diff -= days * 86400

  hours = seconds_diff / 3600
  seconds_diff -= hours * 3600

  minutes = seconds_diff / 60
  seconds_diff -= minutes * 60

  seconds = seconds_diff

  "#{days.to_s.rjust(3,' ')}d #{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
end
#-----------------
# Start to analyze
#-----------------
board = Board.find(board_id)

puts "********************************************"
puts "          Count by list"
puts "********************************************"
board.lists.each do |list|
  list_todo_id = list.id if list.name == configs['trello_list_todo']
  list_ongoing_id = list.id if list.name == configs['trello_list_ongoing']
  #printf "%5s %s\n", list.cards.count, list.name
  puts list.cards.count.to_s.rjust(3,' ') + " " + list.name
end

puts "********************************************"
puts "          Duration of card"
puts "********************************************"
board.lists.each do |list|
  puts "---List: #{list.name}---"
  list.cards.each do |card|
    #puts "---" + card.name + "---"
    #puts card.created_at
    #puts card.last_activity_date.in_time_zone("Asia/Taipei").strftime "%F %T %z"
    puts time_diff(card.created_at,card.last_activity_date) + " " + card.name
  end
  puts "  "
end

#-----------------------------
# Script unlock
#-----------------------------
script.unlock
