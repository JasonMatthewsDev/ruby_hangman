require 'yaml'
require './lib/hangman.rb'

def load_game
  if File.exists?('save/saved.sv')
    game = File.open('save/saved.sv', 'r') { |f| f.read }
    YAML.load(game)
  else
    false
  end
end

if File.exists?('save/saved.sv')
  puts "Would like to load your save (y/n)?"
  input = gets.chomp
  game = input == 'y' ? load_game : Hangman.new('5desk.txt')
else

  game = Hangman.new('5desk.txt')
end

game.begin
