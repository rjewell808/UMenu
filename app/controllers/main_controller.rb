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
		@targets = Dish.where(name: params[:q]).order(:date)
		@foodName = params[:q]
	end
end
