class Movie < ActiveRecord::Base
	def self.get_all_ratings
		return self.find(:all, :select=>"DISTINCT rating",:order=>"rating").map(&:rating)
	end
end
