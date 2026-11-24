# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board, :player

  def initialize
    @board = Board.new
    @player = Player.new('Bob')
    code_array = []
    if self.player.player_role == 'solver'
      4.times { code_array.push(['_r', '_g', '_b', '_y'].sample) }
      @board.code = code_array
    elsif self.player.player_role == 'coder'
      puts 'Enter your code (1 for RED, 2 for GREEN, 3 for BLUE, 4 for YELLOW. Example: 1234):'
      code = gets.chomp
      @board.code = self.number_to_code(code)
    end
  end

  def take_guess
    puts 'Enter your guess (1 for RED, 2 for GREEN, 3 for BLUE, 4 for YELLOW. Example: 1234):'
    guess = gets.chomp
    self.number_to_code(guess)
  end

  def take_guess_from_comp
    guess_array = []
    4.times { guess_array.push(['_r', '_g', '_b', '_y'].sample) }
    guess_array
  end

  def number_to_code(guess)
    guess_array = guess.split('')
    if guess_array.size > 4
      guess_array = guess_array.first(4)
    end
    guess_array_ready = guess_array.map do |element|
      case element
      when '1'
        '_r'
      when '2'
        '_g'
      when '3'
        '_b'
      when '4'
        '_y'
      end
    end
    guess_array_ready
  end

  def take_response(guess)
    guess = guess.dup
    code = @board.code.dup
    response = []
    4.times do |index|
      if code[index] == guess[index]
        response.push('_r')
        guess[index] = nil
        code[index] = nil
      end
    end

    guess.each_with_index do |element, index|
      next if element.nil?

      code.each_with_index do |el, indx|
        if el == element
          response.push('_w')
          guess[index] = nil
          code[indx] = nil
        end
      end
    end

    guess.each do |el|
      if !el.nil?
        response.push('__')
      end
    end
    response
  end

  def play_as_solver
    self.board.render
    12.times do |index|
      guess = self.take_guess
      response = self.take_response(guess)
      self.board.add_guess(guess, index)
      self.board.add_response(response, index)
      self.board.render
      if response[0] == '_r' && response[1] == '_r' && response[2] == '_r' && response[3] == '_r'
        puts 'Player won the game! Congratulations!'
        break
      end
      if index == 11 && !(response[0] == '_r' && response[1] == '_r' && response[2] == '_r' && response[3] == '_r')
        puts 'You loose.'
      end
    end
  end

  def play_as_coder
    self.board.render
    12.times do |index|
      guess = self.take_guess_from_comp
      response = self.take_response(guess)
      self.board.add_guess(guess, index)
      self.board.add_response(response, index)
      self.board.render
      sleep 1
      if response[0] == '_r' && response[1] == '_r' && response[2] == '_r' && response[3] == '_r'
        puts 'Computer won the game! Congratulations!'
        break
      end
      if index == 11 && !(response[0] == '_r' && response[1] == '_r' && response[2] == '_r' && response[3] == '_r')
        puts 'Computer looses. You won!'
      end
    end
  end

  def play
    if self.player.player_role == 'solver'
      self.play_as_solver
    elsif self.player.player_role == 'coder'
      self.play_as_coder
    end
  end
end

game = Game.new
game.play
