module QParser

  class Player

    def initialize(name)
      @name = name
      @deaths = 0
      @kills = 0
      @score = 0
      @kills_means = Hash.new
      @deaths_means = Hash.new
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

    def score
      @score
    end

    def add_death
      @deaths += 1
    end

    def deaths
      @deaths
    end

    def name
      @name
    end

  end

end
