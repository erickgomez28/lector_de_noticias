require 'time'
require_relative 'tools.rb'

class Article
	include Tools

	attr_accessor :article

	def initialize( title, author, date, url, source )
		@article = {:title => check_string(title), :author => check_string(author), :date => check_string(date.strftime("%d/%m/%Y")), :url => url, :source => check_string(source) }
	end
end