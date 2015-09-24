# QParser
  A simple Quake Arena Log Parser
  This project has built in Ruby 2.2.3
----  
#### How to use
  Execute in terminal to parse the log file.
  ````shell
    ruby main.rb
  ```
  To execute the (basic) tests. (Soooo simple tests)
  ````shell
    ruby qparser_testunit.rb
  ```
  
#### Code return
  A example of log parser structure return:
  
````
game_12: {
	game_id: 12,
	total_kills: 1,
	players: [ "Isgalamido" ],
	match_report: {
		[ nickname: "Isgalamido", score: -1, kills: 0, deaths: 1 ]
	}

	kills_by_mean: {
    [ "MOD_TRIGGER_HURT": 1 ]
	}

}
````

  
#### Requirements
  The ```games.log``` file must be in same folder of ```main.rb```.
