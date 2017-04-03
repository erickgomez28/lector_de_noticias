
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