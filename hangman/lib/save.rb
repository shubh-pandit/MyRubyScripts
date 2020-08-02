require 'csv'
class SaveAndLoad
    def save_records(obj)
        CSV.open("saveFiles.csv", "a", headers: true) do |csv|
            csv << [obj.name.downcase, obj.guesses, obj.word, obj.incorrect_guesses, obj.display_word]
        end
    end 

    def load_records(name)
        contents = CSV.open "saveFiles.csv", headers: true, header_converters: :symbol
        contents.each do |row|
            if name.downcase == row[:name]
                return row
            end
        end
        return false
    end
end






