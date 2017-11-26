require 'csv'

class User < ApplicationRecord
    def self.to_csv
        attributes = %w{age mood liking gender ocupation physhic}
        titles = %w{Edad Animo Gustos Genero Ocupacion Fisico}

        CSV.generate(headers: true) do |csv|
            csv << titles


            all.each do |user|
                csv << attributes.map{ |attr| user.send(attr) }
            end
        end
    end

end
