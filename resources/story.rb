require_relative 'distributornews.rb'
require_relative 'tools.rb'
require 'colorize'
require 'launchy'

class Story

	include Tools

	attr_accessor :distributors 

	def initialize
		puts "Por favor espere.\nEstá inicializando..."
		@distributors = { 
			:reddit => DistributorNews.new("https://www.reddit.com/"),
   		 	:mashable => DistributorNews.new("http://mashable.com/stories"),
			:digg => DistributorNews.new("http://digg.com/api/news/popular") 
		}
	end

	def loop_story
		loop do
			system( "clear" )
			puts "Noticiero NO::FACE"
			puts
			puts "1. Mostrar todas las noticias."
			puts "2. Mostrar por distribuidor de noticias." 
			puts "3. Salir."
			puts "Ingrese una opcion: "
			op = getInteger("",0,5)

			case op
				when 1 then
					all_news
				when 2 then
					for_distributor
				when 3 then
					puts
					puts "****Gracias por probarme.****"
					get_keypressed
					system("clear")
					break
			end
		end
	end

	def for_distributor
		loop do
			system( "clear" )
			puts "Noticieros NO::FACE"
			puts
			puts "1. Reddit."
			puts "2. Mashable."
			puts "3. Digg."
			puts "4. Volver."
			puts "Ingrese una opcion: "
			op = getInteger("",0,5)
			puts op
			case op
				when 1 then
					toView(@distributors[:reddit].news)
				when 2 then
					toView(@distributors[:mashable].news)
				when 3 then	
					toView(@distributors[:digg].news)
				when 4 then
					break
			end
		end
	end

	def all_news
		aux = @distributors[:reddit].news + @distributors[:mashable].news + @distributors[:digg].news
		aux.flatten!

		aux.sort!{ | x, y | y.article[:date] <=> x.article[:date] }
		toView( aux )
	end

	def toView( list_news, init = 0 )
		on = init
		key = ''
		
		if list_news.size <= init+20 then
			fin = list_news.size-1
		else
			fin = init+20
		end

		loop do
			system('clear')
			puts "Noticiero NO::FACE"	
			puts "#{'Titulo'.center(35,(' '))} #{'Autor'.center(20,(' '))}#{'Fecha'.center(20,(' '))}".on_blue

			for i in init..fin do
				if i == on then
					puts "  #{(list_news[i].article[:title][0..35]).ljust(40,' ')} #{list_news[i].article[:author][0..15].ljust(20,' ')} #{list_news[i].article[:date].ljust(10,' ')}".white.on_red
				else
					puts "  #{(list_news[i].article[:title][0..35]).ljust(40,' ')} #{list_news[i].article[:author][0..15].ljust(20,' ')} #{list_news[i].article[:date].ljust(10,' ')}"
				end
			end
			
			print_footer(list_news,fin,init)
			
			key, on = key_action(fin,init,list_news, on)
			
			if key == 'x' then
				break
			end
		end
		return key
	end

	def key_action( fin, init, list_news, on )
		
		key = get_keypressed

		if key == 's' && on < fin then
			on += 1
		elsif key == 'w' && on > init then
			on -= 1
		elsif key == 'f' then
			detalles_news(list_news[on].article)
		elsif key == 'd' && fin < list_news.size-1 then
			key = toView(list_news,fin+1)
		elsif key == 'a' then
			if( fin > 20  ) then
				key = toView(list_news,(init-20)-1)
			end
		end
		return key, on
	end	

	def print_footer(list_news,fin,init)
		pag_act = ( fin % 20 == 0 ) ? fin/20 : (fin/20)+1
		pag_total = (list_news.size % 20 == 0 ) ? list_news.size/20 : (list_news.size/20)+1
		print "(<(a) pág (d)> <(w) noticia (s)> <(x) volver> <(f) detalles> )".ljust(65,' ').on_green
		print "pág #{pag_act} de #{pag_total} ".on_green
	end

	def detalles_news( news )
		loop do
			system "clear"
			puts "Noticia\n"
			puts "Titulo:".ljust(15) + news[:title]
			puts "Autor:".ljust(15) + news[:author]
			puts "Fecha:".ljust(15) +news[:date]
			puts "URL:".ljust(15) + news[:url]
			puts "Fuente:".ljust(15) + news[:source]
			
			puts "\n¿Desea acceder a más detalles de esta noticia? (s/n)"
			key = get_keypressed.downcase
			
			if key == 's' then
				puts "Está accediendo a la web..."
				Launchy.open(news[:url]) do |exception|
					puts "Attempted to open #{news[:url]} and failed because #{exception}"
				end
				puts "Ha accedido..."
				break
			elsif key == 'n' then
				puts "Volverá a la ventana anterior."
				break
			else
				puts "Ingrese una opcion correcta. (s: Si/ n: No)"
			end
			
			puts "Presione cualquier tecla para continuar..."
			get_keypressed
		end
	end
end