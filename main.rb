require_relative 'lib/includes.rb'
module QParser
  class Main
      parser = QParser::Parser.new('games.log')
      parser.show_logs
      parser.total_games
  end
end
