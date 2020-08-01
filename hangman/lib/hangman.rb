MAX_ATTEMPTS = 8
class Hangman
    @guesses
    @name
    @word
    @correct
    @incorrect_guesses
    @display_word
    @game
    @ch
    def initialize()
        @ch = nil
        @guesses = 0
        @name = nil
        @word = nil
        @correct = false
        @display_word = []
        @game = false
        @incorrect_guesses = []
    end

    def ask_for_name()
        p "What is your name?"
        name = gets.chomp.to_s
    end

    def initialize_word()
        loop do
            line = rand 3..61405
            file = File.open "5desk.txt", "r"
            line.times { file.gets }
            @word = file.gets
            file.close
            break if (@word.length >= 7) and (@word.length <= 14)
        end
        @word = @word[0..-3].downcase
    end

    def initialize_display_word(len)
        len.times do |i|
            @display_word[i] = "__"
        end
    end


    def compare_word(ch)
        instances_of_ch = []
        if @word.include?(ch)
            @word.split('').each_with_index do |value, index|
                if value == ch
                    instances_of_ch.push(index)
                end
            end
            return instances_of_ch
        else
            return -1
        end
    end
    
    def modify_display_word(arr_ch)
        arr_ch.each do |index|
            @display_word[index] = @word[index]
        end
    end

    def display_hangman()
        print "\n"
        file = File.read "hangman#{@guesses}.txt"
        puts file
        puts "You have #{8 - @guesses} guesses remaining."
    end

    def display_string()
        print "\n"
        @display_word.each {|value| print value + " "}
        print "\n"
    end

    def letter?(lookAhead)
        lookAhead =~ /[A-Za-z]/
    end
    
    def check_input(ch)
        ((ch.length == 1) and letter?(ch)) ? true : false
    end

    def check_win_condition()
        @word.split('') == @display_word ? true : false
    end
    

    def display_incorrect_guesses()
        if @guesses != 0
            print "\n"
            incorrect_guesses = @incorrect_guesses.join(',')
            puts "Incorrect guesses :" + incorrect_guesses
        end
    end

    def begin_game()
        @name = ask_for_name
        puts "Welcome to Hangman!, #{@name}"
        puts "You have a total of 8 attempts to guess the word!"
        puts "Don't let the guy die!"
        initialize_word()
        initialize_display_word(@word.length)
        loop do
            puts "Number of guesses left: #{8 - @guesses}"
            display_hangman
            display_string
            display_incorrect_guesses
            loop do
                puts "Enter your guess! (should be a single character)"
                @ch = gets.chomp.to_s.downcase
                puts "Incorrect input, try again!" if !check_input(@ch)
                break if check_input(@ch)
            end
            inst = compare_word(@ch)
            if inst == -1
                @guesses +=1
                @incorrect_guesses.push(@ch)
            else
                modify_display_word(inst)
            end
            sleep(0.3)
            system("clear") || system("cls")
            @game = check_win_condition()
            break if @game or @guesses == 8
        end

        if @game
            puts "Congratulations! You successfully guessed the word."
        elsif @guesses == 8
            puts "You ran out of attempts! :("
            display_hangman
            print "\n"
            puts "The word was #{@word}"
        end
    end
end

game = Hangman.new
game.begin_game
