module QParser

  class Game

    def initialize(nmb)
      @match_number = nmb
      @players = Hash.new
      @death_cause = Hash.new
      @total_kills = 0
    end

    def id
      @match_number
    end

    def add_global_kills
      @total_kills += 1
    end

    def show_total_kills
      @total_kills
    end

    def add_death_cause(mean)
      @death_cause[mean] ? @death_cause[mean] += 1 : @death_cause.merge!({ mean => 0 })
    end

    def player?(name)
      @players[name] ? true : false
    end

    def join_player(player)
      @players.merge!({player.name => player}) unless player?(player.name)
    end

    def get_player(id)
      @players[id]
    end

    def all_players
      @players
    end

    def list_of_players
      @players.keys.sort
    end

    def describe
      "game_#{@match_number}: {\n"+
          "\tgame_id: #{@match_number},\n"+
          "\ttotal_kills: #{@total_kills},\n"+
    	    "\tplayers: [ " + @players.map{ |n,p| "\"#{n}\"" }.join(", ") + " ],\n" +
    		"\tmatch_report: {\n"+
    		    @players.map{ |n,p| "\t\t[ nickname: \"#{n}\", score: #{p.score}, kills: #{p.kills}, deaths: #{p.deaths} ]" }.join(",\n")+
    		"\n\t}\n\n"+
    		"\tkills_by_mean: {\n"+
    		    @death_cause.map{ |n,p| "\t\t[ \"#{n}\": #{p} ]" }.join(",\n")+
    		"\n\t}\n\n"+

      "},"
    end
  end

end
