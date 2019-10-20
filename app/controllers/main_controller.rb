require 'net/http'
require 'set'

class MainController < ApplicationController
	def home
		Dish.delete_all
		Food.delete_all
		# for x in 0..45
		# 	API.logDay(Time.zone.today - x)
		# end
		API.logDay(Date.today)

		@foods = Food.pluck(:name).uniq
	end

	def food
		@food = Food.find_by(name: params[:q])
		@targets = Dish.where(food_id: @food.id).order(:date)
	end
end
