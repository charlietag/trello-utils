Trello Utilities
=================

# Purpose
1. Fetch info from trello todo list
2. Execute some command with cards name in todo list
3. After this, move cards from todo list to ongoing list

# References

* https://github.com/jeremytregunna/ruby-trello
* http://www.rubydoc.info/gems/ruby-trello/Trello
* https://larry-price.com/blog/2014/03/20/using-the-trello-api-in-ruby/

# Installation

* Download and install dependencies gem packages

  ```bash
  git clone https://github.com/charlietag/trello-utils.git
  bundle install
  ```

# Configuration
* Apply for Trello token
  * public_key
    * https://trello.com/app-key
  * member_token
    * https://trello.com/1/authorize?expiration=never&key={public_key_above}&name=Ruby%20Trello&response_type=token&scope=read%2Cwrite%2Caccount

* Create config file from sample

  ```bash
  cp config/config.yml.sample config/config.yml
  ```

* config.yml

  ```bash
  #API token
  public_key:xxxxxxxxxxxxxxxx
  member_token:yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
  
  # Trello Resource
  trello_account: MyTrelloAccountID #charlie123123
  trello_board: MyBoardName #HelpCenter
  trello_list_todo: MyTodolistName #todo
  trello_list_ongoing: MyOngoingListName #ongoing
  
  # External Command
  # the following example will execute: /script/fetch_data.sh -u www.google.com (assume card.name is "www.google.com"
  # ex. /script/fetch_data.sh -u
  run_command: MyOSCommandOrScriptName
  ```

* Start to use

  ```bash
  ./trello.rb
  ```
