class Hangman

  def initialize(file)
    @file = file
    @tries = 10
    @max_tries = 10
    @guessed = []
  end

  def begin
    puts "you have #{@tries} tries to guess the secret word! You can enter a letter and "\
           "if any of them exist in the word they will be displayed."

    @word ||= select_word
    game_loop
  end

  private #-----------------------------------------------------------------------------------------------
  def game_loop()
    win_block = Proc.new do
      puts "The secret word was #{@word} you win!"
      break
    end

    while @tries > 0
      win_block.call unless display_state.include?('-')

      input = get_input

      if input.length == 1
        @guessed << input
      elsif @word == input
        win_block.call
      elsif input == 'save'
        save_game
        puts "game saved at saves/#{input[5..-1]}"
        @tries += 1
      end

      @tries -= 1
      puts "I'm sorry the secret word was #{@word}, better luck next time!" if @tries == 1
    end
  end

  def load_dictionary(file)
    if File.exists?(file)
      arr = File.readlines(file)
      arr.select! { |line| line.length.between?(5, 12) }
      arr.map { |line| line.downcase.strip }
    else
      return false
    end
  end

  def select_word
    arr = load_dictionary(@file)
    arr.sample if arr
  end

  def get_input
    print "Your guess: "
    input = gets
    input.downcase.strip
  end

  def display_state
    print "Secret Word: "

    word_str = ''
    @word.split('').each {|c| @guessed.include?(c) ? (word_str << c) : (word_str << '-') }
    puts word_str

    puts "Guessed:     #{@guessed.join(' ')}\n"

    turn_str = ''
    turn_str = turn_str.rjust(@tries, 'O')
    turn_str = turn_str.rjust(@max_tries, 'X')
    turn_str = turn_str.rjust(16, ' ')
    puts "Turns: #{turn_str}"

    word_str
  end

  def save_game
    Dir.mkdir('save') unless File.exists?('save')
    File.open("save/saved.sv", 'w') do |f|
      f.puts YAML.dump(self)
    end
  end
end
