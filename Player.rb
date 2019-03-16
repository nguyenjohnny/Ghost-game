
class Player 

    attr_accessor :name 

    def initialize(name)
        @name = name 
    end

    def get_move 
        p '#{name}, to start the game, enter a letter'
        letter = gets.chomp.downcase.strip # strip gets rid of whitespace
    end

    

end 