require_relative 'player.rb'
require 'set'

class Game 

    attr_accessor :dictionary, :current_player, :fragment, :players, :scores, :previous_players
    SCORE_COUNT = 5 

    def initialize(dictionary_file, players)
        @players = players # this is an int 
        @current_player = players[0] # the first player 
        @scores = Hash.new(0) # setting the default score of the hash to 0
        @previous_players = previous_players
        @losses = Hash.new(0)
    end

    def play_round 
        @fragment = ""
        until @dictionary.include?(@fragment)
            take_turn
            next_player!
        end

        p "#{previous_players.name} has lost"
        @losses[previous_players] +=1 
        display_status 
    end

    def play_game 
        play_round until game_over? 
        p "#{winner.name} wins"
    end 

    def display_status
        @losses.each {|k, v| p "#{k.name} = #{v}" }
    end 

    def populate_dictionary(dictionary_file)
        file = File.new(dictionary_file)
        @dictionary = Set.new()
        file.each_line do |line|
            @dictionary << line.chomp # shoveling each line of the file into a set 
        end
    end

    def next_player! 
        @players.rotate! 
        @players.rotate! until @losses[current_plater] < SCORE_COUNT 
    end 

    def valid_play?(str) # returns a boolean to see if this is a valid play
        alpha = 'abcdefghijklmnopqrstuvwxyz'
        return true if alpha.include?(str.lower) 
        false 
    end 

    def take_turn
        # get the move of the player
        current_player_move = current_player.get_move # gets a string from the player 
        # check the fragment against the dictionary 
        if valid_play?(play) 
            update_frag(play) 
        else # if the play is not a valid move, return the string 
            p "#{play} is an unvalid move, try again"
        end
    end

    def update_frag(current_move) # update the fragment with the current move 
        @fragment << current_move 
    end

    def losses
        @current_player = previous_players if scores[current_player] == 5
        @players.delete_if {|player| play == scores.key(5)} # remove the player if they lose the game 
    end

    def end_game
        p "#{players[0].name} is the winner"
    end 

    def game_over?
        return true if players.length == 1
        false 
    end 
end

if __FILE__ == $PROGRAM_NAME
    p 'please give me the number of players'
    number_of_players = Interger(gets.chomp) # retrieves the number of player 

    players = [] 
    for i in 0...number_of_players # indexing the players
        p "Player\##{i} name?" # => Player #1 name? 
        player_name = gets.chomp # fetches the name of the player position
        players << Player.new(player_name) 
    end

    game = Ghost.new('dictionary.txt', players) 
    game.run_game 

end