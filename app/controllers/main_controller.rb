require 'net/http'

class MainController < ApplicationController
	def home
		# Dish.delete_all
		# for x in 0..45
		# 	API.logDay(Date.today - x)
		# end
		@targets = Dish.where(name: "Home Fries").order(:date)
	end
end
