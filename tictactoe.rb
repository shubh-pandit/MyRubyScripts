class TicTacToe
    @player1turn
    @player2turn
    @currentTurn 

    def initialize(player1="player1", player2="player2")
        @player1 = player1
        @player2 = player2
        @game_end = -1
        @board = [['_', '_', '_'],
              ['_', '_', '_'],
              ['_', '_', '_']]
        @currentTurn = false
        puts "Welcome #{@player1} and #{@player2} !"
    end

    public

    def startGame()
        initialize(@player1, @player2)
        while @game_end == -1 do 
            displayBoard()
            @game_end = playerTurn()
        end
        displayCongratulations()
    end

    private

    def displayBoard()
        for i in (0..2)
            p @board[i]
        end
    end

    def playerTurn()
        if @currentTurn == false
            puts "#{@player1}'s turn!"
            @player1turn = gets.chomp.to_s
            index = @player1turn.split('').map!{|value| value.to_i - 1}
            updateBoard(index)
            @currentTurn = true
            return checkWinCondition('O')
        else
            puts "#{@player2}'s turn!"
            @player2turn = gets.chomp.to_s
            index = @player2turn.split('')
            index.map!{|value| value.to_i - 1}
            updateBoard(index)
            @currentTurn = false
            return checkWinCondition('X')
        end
    end

    def updateBoard(index)
        flag = checkValidTurn(index)
        if flag
            if @currentTurn == false
                @board[index[0]][index[1]] = 'O'
            else
                @board[index[0]][index[1]] = 'X'
            end
        end
    end

    def checkValidTurn(index)

        if ((index.all?{|value| (value>2) || (value < 0)}) || (@board[index[0]][index[1]] != '_')) 
            puts "Invalid move! Your turn will be skipped, get cucked lmao faggot"
            return false
        else
            return true
        end
    end


    def checkWinCondition(comp)
        if ((@board[0][0] == comp && @board[0][1] == comp && @board[0][2] == comp) ||
            (@board[1][0] == comp && @board[1][1] == comp && @board[1][2] == comp) ||
            (@board[2][0] == comp && @board[2][1] == comp && @board[2][2] == comp) ||
            (@board[0][0] == comp && @board[1][1] == comp && @board[2][2] == comp) ||
            (@board[0][2] == comp && @board[1][1] == comp && @board[2][0] == comp) ||
            (@board[0][0] == comp && @board[1][0] == comp && @board[2][0] == comp) ||
            (@board[0][1] == comp && @board[1][1] == comp && @board[2][1] == comp) ||
            (@board[0][2] == comp && @board[1][2] == comp && @board[2][2] == comp))
            if comp == 'O'
                return 1
            elsif comp == 'X'
                return 2
            end
        
        elsif @board.all?{ |value| value == 'X' || value == 'O'}
            return 0
        end

        return -1


    end

    def displayCongratulations
        displayBoard
        if @game_end == 1
            puts "Congratulations #{@player1}! You win!"
        elsif @game_end == 2
            puts "Congratulations #{@player2}! You win!"
        else
            puts "You both suck! It was a draw!"
        end
    end
end













        