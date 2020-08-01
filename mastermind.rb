
 CHARSET = ['a','b','c','d','e','f']
 class Mastermind
     MAX_ATTEMPTS = 12
     attr_accessor :attempts, :code, :name, :game, :hint
 
     def initialize() #clear
         @attempts = 1
         @code = generate_code()
         puts "What is your name?"
         @name = gets.chomp
         @hint = []
         @game = false
     end
 
     private
 
     def generate_code()
         code = []
         4.times do |i|
           ch = CHARSET.sample
           if(i == 0)
             code.push(ch)
             next
           end
             loop do
                 ch = CHARSET.sample
                 break if(!(code.include?(ch)))
             end
             code.push(ch)
         end
         return code
     end
   
     def check_code(guess)
         hint = []
         guess.each_with_index do |user, index|
             if @code.include?(user)
                 @code.each_with_index do |guess, index2|
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
         if(guess.all? {|ch| CHARSET.include?(ch)} && guess.length == 4)
             count = Hash.new(0)
             guess.each do |value|
                 count[value] += 1
             end
             return count.length == 4 ? true : false
         else
             return false
         end
     end
     def intro_text
       puts "///////////////////////////////////////////\n\n"
       puts "   Welcome to Mastermind!   \n\n"
       puts "   You have 12 guesses to crack a code of four letters. Each letter may be a, b, d, e, or f.\n\n"
       puts "   Please guess by typing in four letter.\n\n"
       puts "   The computer will give you feedback once you have guessed the code.\n\n"
       puts "   Correct letter in the right place = 'O' , correct letter in the wrong place = '#' , wrong letter and wrong place = 'X'  \n\n"
       puts "///////////////////////////////////////////\n\n"
     end
     public
 
     def begin_game()
       intro_text
       puts "Do you want to play as the code setter (1) or the code guesser (2)?"
       choice = gets.chomp
       if (choice == '1')
         computer_game()
       else
         user_game()
       end
     end
 
 
     def user_game()
         puts "Guess the code!"
         loop do
             print "\n"
             puts("Attempt number #{@attempts}")
             puts "Input your guess"
             guess = gets.chomp.to_s.chars
             if !correct_input(guess)
                 puts "Incorrect input"
                 next
             end
             hint = check_code(guess)
             hint.all? {|ch| ch == 'O'} ? @game = true : @game = false
             @game ? puts("Congratulations! You guessed correctly. It took you #{@attempts} attempts.") : print(hint)
             @attempts += 1
             if((@attempts == MAX_ATTEMPTS) or (@game == true))
               break
             end
         end
         puts("You ran out attempts. Better luck next time!") if ((@game == false) && (@attempts == MAX_ATTEMPTS))
     end
 
   def computer_game()
     ai = ComputerAI.new
     puts "You are the code setter!"
     loop do
       puts "Give a code of length 4"
       @code = gets.chomp.to_s.chars
       if !correct_input(@code)
           puts "Incorrect input, try again"
           next
       else
         break
       end
     end
     puts "The computer will try to guess your code!"
     loop do
       print "\n"
       puts "Attempt number #{@attempts}"
       puts "The computer is making a guess!"
       guess = ai.guess(@attempts, @hint)
       sleep(2)
       print guess
       print "\n"
       hint = check_code(guess)
       @hint = hint
       hint.all? {|ch| ch == 'O'} ? @game = true : @game = false
       @game ? puts("The computer succesfully cracked the code! It took the computer #{@attempts} attempts.") : print(hint)
       @attempts += 1
       if((@attempts == MAX_ATTEMPTS) or (@game == true))
         break
       end
     end
 
       puts("\nThe computer ran out of attempts!") if ((@game == false) && (@attempts == MAX_ATTEMPTS))
   end
 end
 
 
   
 class ComputerAI
   @previous_guess
   @current_guess
   @incorrect
   def initialize()
     @previous_guess = []
     @current_guess = []
     @incorrect = []
   end
 
   def generate_code(n = 4)
       code = []
       n.times do |i|
         ch = CHARSET.sample
         if(i == 0)
           code.push(ch)
           next
         end
           loop do
               ch = CHARSET.sample
               break if(!(code.include?(ch)))
           end
           code.push(ch)
       end
       return code
   end
   public
   def guess(attempts, hint)
     flag = false
     number = -1
     ch = 'z'
     indices = [0,1,2,3]
     if attempts == 1
       @previous_guess = generate_code
       return @previous_guess
     else
       hint.each_with_index do |value, index|
         if value == 'O'
           @current_guess[index] = @previous_guess[index]
           indices = indices - [index]
         end
       end
       hint.each_with_index do |value, index|
         if value == '#'
           loop do
             number = indices.sample
             break if ((index != number) or (indices.length == 1))
           end
           indices = indices - [number]
           @current_guess[number] = @previous_guess[index]
         end
       end
       hint.each_with_index do |value, index|
         if value == 'X'
           @incorrect.push(value)
         end
       end
       hint.each_with_index do |value, index|
         if value == 'X'
           loop do
                 ch = CHARSET.sample
                 flag = (!(@incorrect.include?(ch)) && !(@previous_guess.include?(ch)) && !(@current_guess.include?(ch)))
                 break if flag
           end
           number = indices.sample
           indices = indices - [number]
           @current_guess[number] = ch
         end
       end
       @previous_guess = @current_guess.clone
       return @current_guess
     end
   end
 end
 
 myGame = Mastermind.new
 myGame.begin_game
 
 
 
 
 
 
 
 
 
 
 
             
             
 
 
 
 
 
 