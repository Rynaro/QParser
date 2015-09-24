require "./lib/includes.rb"
require "test/unit"

class TestParser < Test::Unit::TestCase

  def setup
    @log_file = QParser::Parser.new('games.log')
  end

  def test_new_game?
    assert_equal(true, @log_file.send(:new_game?, '  0:00 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0'))
  end

  def test_get_killer
    assert_equal("<world>", @log_file.send(:get_killer, '  3:51 Kill: 1022 2 19: <world> killed Dono da Bola by MOD_FALLING'))
  end

  def test_get_victim
    assert_equal("Isgalamido", @log_file.send(:get_victim, '  4:08 Kill: 4 3 7: Zeh killed Isgalamido by MOD_ROCKET_SPLASH'))
  end

  def test_get_player
    assert_equal("Assasinu Credi", @log_file.send(:get_player, '  3:47 ClientUserinfoChanged: 5 n\Assasinu Credi\t\0\model\sarge\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\95\w\0\l\0\tt\0\tl\0'))
  end

end


class TestGame < Test::Unit::TestCase
  def setup
    @game = QParser::Game.new(15)
  end

  def test_game_id
    assert_equal(15, @game.send(:id))
  end

  def test_join_player
    @game.join_player(QParser::Player.new("Henrique42"))
    assert_equal(true, @game.send(:player?, "Henrique42"))
  end

  def test_global_kill
    @game.add_global_kills
    assert_equal(1, @game.send(:show_total_kills))
  end

end

class TestPlayer < Test::Unit::TestCase

  def setup
    @player = QParser::Player.new("Henrique-Miner")
  end

  def test_add_kill
    @player.add_kill
    @player.add_kill
    assert_equal(2, @player.send(:kills))
  end

  def test_add_score
    @player.minus_score
    assert_equal(-1, @player.send(:score))
    @player.add_score
    @player.add_score
    assert_equal(1, @player.send(:score))
  end

  def test_check_name
    assert_equal("Henrique-Miner", @player.send(:name))
  end
end
