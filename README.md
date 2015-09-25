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
  A example of log parser structure returns:

````
game-12: {
	game_id: 12,
	endgame_by:  Fraglimit hit,
	total_kills: 14,
	world_casualities: 5,
	connected_players_list: [ "Isgalamido", "Zeh", "Assasinu Credi"  ],
	match_final_ranking: {
		[ id: 3, nickname: "Isgalamido", score: 2, kills: 2, deaths: 0 ],
		[ id: 2, nickname: "Zeh", score: 1, kills: 2, deaths: 5 ],
		[ id: 5, nickname: "Assasinu Credi", score: -3, kills: 3, deaths: 8 ]
	}

	disconnected_players_report: {
		[ id: 4, nickname: "Zeh", score: 0, kills: 0, deaths: 1 ],
	}

	kills_by_mean: {
		[ "MOD_GRENADE_SPLASH": 4 ],
		[ "MOD_ROCKET": 4 ],
		[ "MOD_TARGET_LASER": 5 ],
		[ "MOD_PLASMA_SPLASH": 1 ]
	}

	nicknames_by_id: {
		[ id: 2, played_as: [Dono da Bola, Zeh] ],
		[ id: 3, played_as: [Isgalamido] ],
		[ id: 4, played_as: [Zeh] ],
		[ id: 5, played_as: [Assasinu Credi] ]
	}

	first_blood: {
		time: 23:44, killer_id: 1, victim_id: 5
	}

}
````

````disconnected_players_report````, ````kills_by_mean````,  ````first_blood````, not appears when dont have data to show.

````match_final_ranking```` will be rank the players who not exited the room before the match ends.

````disconnected_players_report```` show the players stats who appeared in room in any moment.

````nicknames_by_id```` show the players who have switched their nicks ingame, or outgame and reentered in room.

````first_blood```` show the first blood statistics, with time, killer_id, victim_id.



#### Requirements
  The ```games.log``` file must be in same folder of ```main.rb```.
