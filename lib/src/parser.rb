module QParser

  class Parser
    attr_accessor :means

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

    def initialize file_path
      file = File.open(file_path) { |f| f.read }
      @matches = 0
      @games = Array.new
      file.each_line do |ln|
        if new_game? ln
          @games.push(Game.new(@matches))
          @matches += 1
        elsif new_player?(ln)
          @games.last.join_player(Player.new(get_player(ln)))
        elsif kill? ln
          @games.last.add_global_kills
          @games.last.add_death_cause(get_death_cause(ln))
          killer_name = get_killer(ln)
          player_victim = @games.last.get_player(get_victim(ln))
          player_victim.add_death
          if killer_name == "<world>"
            player_victim.minus_score
          elsif killer_name == player_victim.name
            player_victim.minus_score
          else
            player_killer = @games.last.get_player(killer_name)
            player_killer.add_kill
            player_killer.add_score
          end
        end
      end
    end

    def new_game?(str)
      str=~/^\s{0,2}\d{1,3}:\d{2} InitGame:/ ? true : false
    end

    def new_player?(str)
      str=~/^(\d{3}|\s\d{2}|\s{2}\d{1}):\d{2} ClientUserinfoChanged:/ ? true : false
    end

    def get_player(str)
      str[/n\\.+\\t\\\d/].gsub(/^n\\|\\t\\\d/, '')
    end

    def kill?(str)
      str=~/^ \d{1,3}:\d{2} Kill:/ ? true : false
    end

    def get_killer(str)
      str[/(#{@games.last.list_of_players.push('<world>').join('|')}) killed/].gsub(/ killed/, '')
    end

    def get_victim(str)
      str[/(#{@games.last.list_of_players.join('|')}) by/].gsub(/ by/, '')
    end

    def get_death_cause(str)
      str[/(#{MEANS.join('|')})/]
    end

    def show_logs
      @games.each { |g| puts "#{g.describe}\n" }
    end

    def total_games
      puts "total_games: #{@games.last.id + 1}"
    end
  end
end
