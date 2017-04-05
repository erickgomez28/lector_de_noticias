
module Tools

	def get_keypressed
		system("stty raw -echo")
		t = STDIN.getc
		system("stty -raw echo")

		return t
	end

	def check_string( text )
		if ( text == nil )
			return "No posee"
		end
		return text
	end


	def pritn_menu( options, on )
		system('clear')
		options.each_with_index do | option, i |
			if i == 0 then
				if option != nil then
					puts "#{option}"
					puts
				end
			elsif on == i then
				puts "\t#{i}. #{option}".on_red
			else
				puts "\t#{i}. #{option}"
			end
		end
	end
	
	def menu( *options )
		on = 1
		loop do
			pritn_menu(options, on)

			key = get_keypressed.downcase

			if key == 's' && on < options.length-1 then
				on += 1
			elsif key == 'w' && on > 1 then
				on -= 1
			elsif key == 'f' then
				return on
			# elsif key == 'd' && fin < list_news.size-1 then

			# elsif key == 'a' then
			elsif key == 'x' then
				return -1
			end
		end
	end

	def getInteger( text, min, max )

		n = 0
		on = true

		loop do 
			puts
			print text
			n = gets.chomp.to_i		

			if ( n > min && n < max )
				on = false
			else
				on = true
				puts
				puts "Debe ingresar un numero del #{min+1} y #{max-1}."
				puts "Presione una tecla para continuar..."
				get_keypressed
			end

			break if on == false
		end
		return n
	end
end