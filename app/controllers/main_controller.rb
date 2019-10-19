require 'net/http'

class MainController < ApplicationController
	def home
		# Dish.delete_all
		# for x in 0..45
		# 	API.logDay(Date.today - x)
		# end

		@foods = Dish.pluck(:name).uniq
	end

	def food
		@targets = Dish.where(name: params[:q]).order(:date)
	end
end
