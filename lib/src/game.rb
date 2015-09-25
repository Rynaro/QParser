module QParser

  class Game

    def initialize(nmb)
      @match_number = nmb
      @players = Hash.new
      @death_cause = Hash.new
      @first_blood = Array.new
      @total_kills = 0
      @exit = ''
      @world_casualities = 0
    end

    def id
      @match_number
    end

    def get_player(id)
      @players[id]
    end

    def show_total_kills
      @total_kills
    end

    def exit_cause
      @exit
    end

    def add_global_kills
      @total_kills += 1
    end

    # adds counter to world; world is cruel
    def add_world_casualities
      @world_casualities += 1
    end

    def add_death_cause(mean)
      @death_cause[mean] ? @death_cause[mean] += 1 : @death_cause.merge!({ mean => 1 })
    end

    def set_exit_cause(cause)
      @exit = cause
    end

    # controls all player activity; is a new player? add in match; change name? change the name and store past name;
    # reconnect to match? set online status
    def player_activity(player)
      the_player = get_player(player[0])
      if the_player
        the_player.change_status if the_player.status == 'offline'
        the_player.change_name(player[1])
      else
        @players.merge!({player[0] => Player.new(player[0], player[1])})
      end
    end

    # check if kill is a first blood, and store data
    def first_blood?(time, killer, victim)
      if @first_blood.size == 0
        @first_blood = [time, killer, victim]
      end
    end

    def all_players
      @players
    end

    # sort players by score relevance, to make a ranking like organization
    def ranking_players(status)
      @players.values.sort { |k, v| k.score <=> v.score }.reverse.select{ |v| v if v.status == status }
    end

    def render_first_blood
      if @first_blood.size > 0
      "\tfirst_blood: {\n"+
          "\t\ttime: #{@first_blood[0]}, killer_id: #{@first_blood[1]}, victim_id: #{@first_blood[2]}"+
      "\n\t}\n\n"
      end
    end

    def render_kills_by_mean
        if @death_cause.size > 0
        "\tkills_by_mean: {\n"+
            @death_cause.map{ |n,p| "\t\t[ \"#{n}\": #{p} ]" }.join(",\n")+
        "\n\t}\n\n"
      end
    end

    def render_nicknames_by_id
      "#{render_kills_by_mean}"+
      "\tnicknames_by_id: {\n"+
          @players.map{ |n,p| "\t\t[ id: #{n}, played_as: [#{p.history_names}] ]" }.join(",\n")+
      "\n\t}\n\n"
    end

    def render_final_ranking
      "\tmatch_final_ranking: {\n"+
          ranking_players('online').map{ |n| "\t\t[ id: #{n.id}, nickname: \"#{n.name}\", score: #{n.score}, kills: #{n.kills}, deaths: #{n.deaths} ]" }.join(",\n")+
      "\n\t}\n\n"
    end

    def render_disconnected_players
      if ranking_players('offline').size > 0
        "\tdisconnected_players_report: {\n"+
            ranking_players('offline').map{ |n| "\t\t[ id: #{n.id}, nickname: \"#{n.name}\", score: #{n.score}, kills: #{n.kills}, deaths: #{n.deaths} ]" }.join(",\n")+
        "\n\t}\n\n"
      end
    end

    def describe
      "game-#{@match_number}: {\n"+
          "\tgame_id: #{@match_number},\n"+
          "\tendgame_by: #{@exit},\n"+
          "\ttotal_kills: #{@total_kills},\n"+
          "\tworld_casualities: #{@world_casualities},\n"+
    	    "\tconnected_players_list: [ " + ranking_players('online').map{ |n| "\"#{n.name}\"" }.join(", ") + " ],\n" +
          "#{render_final_ranking}"+
          "#{render_disconnected_players}"+
          "#{render_nicknames_by_id}"+
          "#{render_first_blood}"+
      "},"
    end
  end

end
