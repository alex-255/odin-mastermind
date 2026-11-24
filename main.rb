# frozen_string_literal: true

require_relative 'board'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    code_array = []
    4.times { code_array.push(['_r', '_g', '_b', '_y'].sample) }
    @board.code = code_array
  end

  def take_guess
    puts 'Enter your guess (1 for RED, 2 for GREEN, 3 for BLUE, 4 for YELLOW. Example: 1234):'
    guess = gets.chomp
    guess_array = guess.split('')
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

  def play
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
end

game = Game.new
game.play
