require 'net/http'

class MainController < ApplicationController
	def home
		# Dish.delete_all
		# for x in 0..45
		# 	API.logDay(Date.today - x)
		# end
		#API.logDay(Date.today - 3)

		@foods = Dish.pluck(:name).uniq
	end

	def food
		@targets = Dish.where(name: params[:q]).order(:date)
		@foodName = params[:q]
	end
end
