require_relative 'lib/includes.rb'
module QParser
  class Main
    begin
      parser = QParser::Parser.new('games.log')
      parser.show_logs
      parser.total_games
    rescue
      puts 'Where is my games.log file? :( (Make sure that you have de games.log file is inside of same level of main.rb)'
    end
  end
end
