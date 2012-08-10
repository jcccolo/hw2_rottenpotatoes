class Movie < ActiveRecord::Base

  @@ratings = ['G', 'PG', 'PG-13', 'R', 'NC-17']
  
  def self.ratings
    @@ratings
  end
end
