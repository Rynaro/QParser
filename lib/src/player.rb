module QParser

  class Player

    attr_accessor :id, :name, :deaths, :kills, :score, :status

    def initialize
      @past_names = Array.new
      @status = true
      @deaths = 0
      @kills  = 0
      @score  = 0
      @kills_means = Hash.new
      @deaths_means = Hash.new
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
