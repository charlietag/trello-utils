#!/usr/local/bin/ruby
require 'yaml'
require 'trello'
include Trello

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
  cmd = "#{configs['run_command']} #{card.name} 2>/dev/null"
  cmd_result = %x(#{cmd})
  #puts $?.exitstatus
  if $?.exitstatus == 0
    #puts "yes"
    card.add_comment(cmd_result)
    card.move_to_list(list_ongoing_id)
    #puts cmd_result
  #else
    #puts "no"
    #puts cmd_result
  end
end
