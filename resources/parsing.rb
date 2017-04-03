require 'json'
require 'rest-client'
require 'addressable/uri'
require_relative 'article.rb'
require 'time'

module Parsing
		
	attr_accessor :patch, :json, :url

	def parsing
		JSON.parse( RestClient.get( @url.to_s ) )
	end

	def get_news(url)
		@url = Addressable::URI.parse(url +'.json')
		
		case @url.host
		when 'mashable.com' then
			
			@json = parsing['new']
			news = @json.map{ | ad | Article.new( ad['title'], ad['author'], Time.parse(ad['post_date']), ad['link'],@url.host ) }

		when 'www.reddit.com' then

			@json = parsing['data']['children']
			news = @json.map{ | ad | Article.new( ad['data']['title'], ad['data']['author'], Time.at(ad['data']['created'].to_i), ad['data']['url'], @url.host ) }

		when 'digg.com' then
			@json = parsing['data']['feed']
			news = @json.map{ | ad | Article.new( ad['content']['title_alt'], ad['content']['author'], Time.at(ad['date'].to_i), ad['content']['url'], @url.host ) }
		end

		return news
	end

	def get_name
		@url.host
	end

end
