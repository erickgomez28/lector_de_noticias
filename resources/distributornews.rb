require_relative 'article.rb'
require_relative 'parsing.rb'

class DistributorNews
	
	include Parsing

	attr_accessor :news, :name

	def initialize( url )
		@news = get_news(url)
		@name = get_name
	end

end