module QParser

  class Parser

    # constant array with means (extracted from Quake source)
    MEANS = [
      'MOD_RAILGUN',
  		'MOD_UNKNOWN',
  		'MOD_SHOTGUN',
  		'MOD_GAUNTLET',
  		'MOD_MACHINEGUN',
  		'MOD_GRENADE',
  		'MOD_GRENADE_SPLASH',
  		'MOD_ROCKET',
  		'MOD_ROCKET_SPLASH',
  		'MOD_PLASMA',
  		'MOD_PLASMA_SPLASH',
  		'MOD_RAILGUN',
  		'MOD_LIGHTNING',
  		'MOD_BFG',
  		'MOD_BFG_SPLASH',
  		'MOD_WATER',
  		'MOD_SLIME',
  		'MOD_LAVA',
  		'MOD_CRUSH',
  		'MOD_TELEFRAG',
  		'MOD_FALLING',
  		'MOD_SUICIDE',
  		'MOD_TARGET_LASER',
  		'MOD_TRIGGER_HURT',
  		'MOD_NAIL',
  		'MOD_CHAINGUN',
  		'MOD_PROXIMITY_MINE',
  		'MOD_KAMIKAZE',
  		'MOD_JUICED',
  		'MOD_GRAPPLE'
		]

    # This function will be call all parsing methods and game rules information
    def initialize(file_path)
      file = File.open(file_path) { |f| f.read }
      @matches = 1
      @games = Array.new
      file.each_line do |ln|
        if new_game?(ln)
          # set Unknown cause, if server don't return a conclusive cause
          @games.last.set_exit_cause("Unknown") if @games.last != nil && @games.last.exit_cause == ''
          @games.push(Game.new(@matches))
          @matches += 1
        elsif end_game?(ln)
          # set exit server cause
        @games.last.set_exit_cause(end_game_cause(ln))
        elsif player_changes?(ln)
          # set changes in player (by id), change name, or connected/online status
          @games.last.player_activity(get_player(ln))
        elsif player_disconnect?(ln)
          # set disconnected/offline status for player
          player = @games.last.get_player(player_disconnected(ln))
          player.change_status
        elsif kill?(ln)
          # register all kills in game; suicides, world casualities and normal kills (pvp)
          kill = get_kill_report(ln)
          @games.last.add_global_kills
          @games.last.add_death_cause(MEANS[kill[2]])

          player_victim = @games.last.get_player(kill[1])
          player_victim.add_death
          if kill[0] == 1022
            player_victim.minus_score
            @games.last.add_world_casualities
          elsif kill[0] == kill[1]
            player_victim.minus_score
          else
            player_killer = @games.last.get_player(kill[0])
            player_killer.add_kill
            player_killer.add_score
            @games.last.first_blood?(kill[3], kill[0], kill[2])
          end
        end
      end
      # force last row to Unknown cause, if don't have conclusive cause
      @games.last.set_exit_cause("Unknown") unless @games.last.exit_cause
    end

    # Return true if found InitGame in string;
    def new_game?(str)
      str=~/^\s{0,2}\d{1,3}:\d{2} InitGame:/ ? true : false
    end

    # Return true if found Exit in string;
    def end_game?(str)
      str=~/^\s{0,2}\d{1,3}:\d{2} Exit: / ? true : false
    end

    # Return the server exit cause;
    def end_game_cause(str)
      str[/^\s{0,2}\d{1,3}:\d{2} Exit: (.*)/].gsub(/^\s{0,2}\d{1,3}:\d{2} Exit:|.$/, '')
    end

    # Return true if found ClientDisconnect;
    def player_disconnect?(str)
      str=~/^ \d{1,3}:\d{2} ClientDisconnect: / ? true : false
    end

    # Return player ID who have exited the room;
    def player_disconnected(str)
      str[/^ \d{1,3}:\d{2} ClientDisconnect: \d{1,2}/].gsub(/^ \d{1,3}:\d{2} ClientDisconnect: /, '').to_i
    end

    # Return true if found ClientUserinfoChanged; Client/Player changing data
    def player_changes?(str)
      str=~/^(\d{3}|\s\d{2}|\s{2}\d{1}):\d{2} ClientUserinfoChanged:/ ? true : false
    end

    # Return player ID
    def get_player(str)
      [str[/\d{1,2} n\\/].gsub(/ n\\/, '').to_i ,str[/n\\.+\\t\\\d/].gsub(/^n\\|\\t\\\d/, '')]
    end

    # Return true if found Kill; Kill action in game
    def kill?(str)
      str=~/^ \d{1,3}:\d{2} Kill:/ ? true : false
    end

    # Return all kill information based on ID (killer_id, victim_id, mean_id, time)
    def get_kill_report(str)
      @return = str[/Kill: \d{1,4}\s\d{1,2}\s\d{1,2}/].gsub(/^Kill: /, '').split(' ').map{ |i| i.to_i }
      @return.push(str[/\d{1,3}:\d{2}/].gsub(/^Kill: /, ''))
      @return
    end

    # Show all logs
    def show_logs
      @games.each { |g| puts "#{g.describe}\n" }
    end

    def total_games
      puts "total_games: #{@games.last.id + 1}"
    end
  end
end
