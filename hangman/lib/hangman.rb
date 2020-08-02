MAX_ATTEMPTS = 8
require_relative 'save.rb'
class Hangman
    attr_accessor :guesses, :name, :word, :incorrect_guesses, :display_word
    @game
    @ch
    def initialize()
        @ch = nil
        @guesses = 0
        @name = nil
        @word = nil
        @display_word = []
        @game = false
        @incorrect_guesses = []
    end

    def initialize_save(data)
        @name = data[:name].to_s
        @guesses = data[:guesses].to_i
        @word = data[:word].to_s
        parse_incorrect_guesses(data[:incorrect_guesses])
        parse_display_word(data[:display_word])
        @game = false
        @ch = nil
    end

    def parse_incorrect_guesses(data)
        @incorrect_guesses = []
        data = data.split('')[1..-1]
        data.each {|value| @incorrect_guesses.push(value) if letter?(value)}
    end

    def parse_display_word(data)
        @display_word = []
        data = data.split('')[1..-1]
        data.each {|value| @display_word.push(value) if letter?(value) or value == '_'}
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
            @display_word[i] = "_"
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
    end

    def display_string()
        print "\n"
        @display_word.each {|value| print value + "  "}
        print "\n"
    end

    def letter?(lookAhead)
        lookAhead =~ /[A-Za-z]/
    end
    
    def check_input(ch)
        if ((ch.length == 1) and letter?(ch))
            return 1
        elsif ch == "save"
            return 0
        elsif ch == "load"
            return -1
        else
            return -2
        end
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

    def parse_data(name)
        file = SaveAndLoad.new
        data = file.load_records(name)
        if data
            initialize_save(data)
        else
            puts "Save file not found!"
        end
    end

    def save_data()
        file = SaveAndLoad.new
        file.save_records(self)
    end

    def begin_game()
        @name = ask_for_name
        puts "Welcome to Hangman!, #{@name}"
        puts "Type load to load a previous game."
        puts "Type save anytime to save your progress."
        puts "You have a total of 8 attempts to guess the word!"
        puts "Don't let the guy die!"
        initialize_word()
        initialize_display_word(@word.length)
        loop do
            puts "Number of guesses left: #{MAX_ATTEMPTS - @guesses}"
            display_hangman
            display_string
            display_incorrect_guesses
            loop do
                puts "Enter your guess! (should be a single character) or use save/load"
                @ch = gets.chomp.to_s.downcase
                puts "Incorrect input, try again!" if check_input(@ch) == -2
                break if check_input(@ch) !=-2
            end
            if check_input(@ch) == 0
                save_data
                puts "Saving your data!"
                sleep(2)
                next
            elsif check_input(@ch) == -1
                puts "Loading your data!"
                sleep(2)
                parse_data(@name)
                next
            else
                inst = compare_word(@ch)
                if inst == -1
                    @guesses +=1
                    @incorrect_guesses.push(@ch)
                else
                    modify_display_word(inst)
                end
                @game = check_win_condition()
            end
            sleep(0.5)
            system("clear") || system("cls")
            break if @game or @guesses == MAX_ATTEMPTS
        end

        if @game
            puts "Congratulations #{@name}! You successfully guessed the word."
        elsif @guesses == MAX_ATTEMPTS
            puts "You ran out of attempts! :("
            display_hangman
        end
        print "\n"
        puts "The word was #{@word}"
    end
end

game = Hangman.new
game.begin_game
