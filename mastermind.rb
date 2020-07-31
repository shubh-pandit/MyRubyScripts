class mastermind
    MAX_ATTEMPTS = 12
    CHARSET = [a,b,c,d,e,f]
    attr_accessor :attempts, :code, :name
    @game

    def initialize()
        @attempts = 0
        @code = self.generate_code()
        puts "What is your name?"
        @name = gets.chomp
        @hint = []
        @game = false
    end

    def generate_code()
        code = []
        for i in 0..3
            loop do:
                ch = CHARSET.sample
                break if !(code.include?(ch))
            end
            code.push(ch)
        end
    end

    def begin_game()
        puts "Welcome #{@name}, let's play Mastermind!"
        puts "Guess the code!"
        loop do:
            puts "Attempt ##{@attempts}"
            puts "Input your guess"
            guess = gets.chomp.to_s.downcase!
            if !correct_input(guess)
                puts "Incorrect input"
                next
            end
            hint = self.check_code(guess)
            hint.all? {|ch| ch == 'O'} ? @game = true : @game = false
            @game ? puts "Congratulations! You guessed correctly. It took you " + @attempts " attempts." : puts hint
            @attempts += 1
            break if @attempts == MAX_ATTEMPTS or @game == true
        end

        if @game == false and @attempts == MAX_ATTEMPTS
            puts "You ran out attempts. Better luck next time!"
        end
        


    end

    def check_code(guess)
        hint = []
        guess.each_with_index do |user, index|:
            if @code.include?(user)
                @code.each_with_index do |guess, index2|:
                    if user == guess
                        if index == index2
                            hint.push('O')
                        else
                            hint.push('#')
                        end
                        break
                    end
                end
            else
                hint.push('X')
            end
        end
        return hint
    end

    def correct_input(guess)
        if guess.all? {|ch| ch in CHARSET}
            guess.reduce(Hash.new(0)) do |count, value|
                count[value] += 1
            end
            return count.length == 4 ? true : false
        else
            return false
        end
    end
end

myGame = 









            
            





