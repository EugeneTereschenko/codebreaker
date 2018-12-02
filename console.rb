require './autoload.rb'
require './lib/game.rb'
require './lib/validation.rb'

loop do
  puts 'Welcome to game Codebreaker'
  game = Game.new
  puts game.phrases['wel_instruct']

  answ = gets.chomp
  case answ
  when 'start' then
    game.choose_name
    game.new_game
  when 'rules' then
    puts game.phrases['rulegame']
  when 'stats' then game.stats
  when 'exit' then exit
  end
end
