module QParser

  class Player

    def initialize(id, name)
      @id = id
      @name = name
      @past_names = Array.new
      @status = true
      @deaths = 0
      @kills = 0
      @score = 0
      @kills_means = Hash.new
      @deaths_means = Hash.new
    end

    def change_status
      @status = !@status
    end

    def add_death
      @deaths += 1
    end

    def add_kill
      @kills += 1
    end

    def kills
      @kills
    end

    def add_score
      @score += 1
    end

    def minus_score
      @score -= 1
    end

    def id
      @id
    end

    def status
      @status ? 'online' : 'offline'
    end

    def score
      @score
    end

    def deaths
      @deaths
    end

    def name
      @name
    end

    # get historic with nicknames who the player played
    def history_names
      @past_names.push(@name).join(", ")
    end

    # change nickname, if player do it; store pat nickname in historic array
    def change_name(actual_name)
      unless actual_name == @name
        @past_names.push(@name)
        @name = actual_name
      end
    end

  end

end
