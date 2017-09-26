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
list_todo_id = ""
list_ongoing_id = ""
board = Board.find(board_id)
board.lists.each do |list|
  list_todo_id = list.id if list.name == configs['trello_list_todo']
  list_ongoing_id = list.id if list.name == configs['trello_list_ongoing']
end

#-----------------------------
# Dealing with cards
#-----------------------------
list = List.find(list_todo_id)
list.cards.each do |card|
  card.name.strip!

  if configs['string_type'] == 'url'
    require 'addressable/uri'
    uri = Addressable::URI.parse(card.name).host rescue nil # rescue error for none URL string
    uri = Addressable::URI.parse("http://" + card.name).host if uri.nil? rescue nil # rescue error for none URL string
    card.name = uri unless uri.to_s.empty?
  end

  cmd = "#{configs['run_command']} #{card.name} 2>/dev/null"
  cmd_result = %x(#{cmd})
  #puts $?.exitstatus

  #if $?.exitstatus == 0
  #  puts "-------Success: #{card.name}-------"
  #else
  #  puts "-------Failure: #{card.name}-------"
  #end
  puts "--------------#{card.name}---------------"
  card.add_comment("```\n" + cmd_result + "\n```")
  card.save
  card.move_to_list(list_ongoing_id)
  puts cmd_result
end

#-----------------------------
# Script unlock
#-----------------------------
script.unlock
