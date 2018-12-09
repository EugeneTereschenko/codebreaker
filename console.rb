require './autoload.rb'
require './lib/game.rb'
require './lib/validation.rb'

loop do
  puts I18n.t :start_game
  game = Game.new
  puts I18n.t :wel_instruct

  answ = gets.chomp
  case answ
  when 'start' then
    game.choose_name
    game.new_game
  when 'rules' then
    puts I18n.t :rulegame
  when 'stats' then game.stats
  when 'exit' then exit
  end
end
