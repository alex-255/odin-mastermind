class Player
  attr_reader :player_role

  def initialize(name)
    @name = name
    @player_role = self.choose_player_role
  end

  def choose_player_role
    puts 'Choose player\'s role. 1 for coder. 2 for solver.'
    choice = gets.chomp
    if choice == '1'
      'coder'
    elsif choice == '2'
      'solver'
    end
  end
end
