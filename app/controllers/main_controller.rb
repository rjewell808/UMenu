require 'net/http'
require 'set'

class MainController < ApplicationController
	def home
		if Dish.where(date: Time.zone.today).size < 1
			API.logDay(Time.zone.today)
		end
		@foods = Food.pluck(:name).uniq
	end

	def food
		@food = Food.find_by(name: params[:q])
		@targets = Dish.where(food_id: @food.id).order(:date)

		@frequencies = []
		@last_day = nil

		uniq_dates = @targets.pluck(:date).uniq

		uniq_dates.each do |date|
			if @last_day == date
				next
			end

			if !@last_day.nil?
				@frequencies.append(date - @last_day)
			end
			@last_day = date
		end
		@today = Time.zone.today

		@days_weights = []
		start_date = @today
		end_date = uniq_dates.first
		Date::DAYNAMES.each_with_index do |day, ind|
			weeks = (end_date..start_date).to_a.select {|k| k.wday == ind }.size
			@days_weights.append(weeks == 0 ? 0 : ((uniq_dates.select {|d| d.wday == ind }.size / weeks.to_f) * 100).to_i)
	 	end

		@avg_cycle = @frequencies.sum / @frequencies.size.to_f
		@next_serving = -1

		puts @days_weights

		if @avg_cycle % 7 == 0
			@next_serving = (@today + (@avg_cycle - (@today - @last_day)))
		elsif @avg_cycle == 1
			@next_serving = @today + 1
		elsif @days_weights.include? 100
			weight_index = @last_day.wday
			total = 0

			while total < 7
				if @days_weights[weight_index] == 100
					@next_serving = @last_day + weight_index
					break
				else
					weight_index += 1

					if weight_index > 6
						weight_index = 0
					end
					total += 1
				end
			end
		end
			
		if @next_serving != -1
			@next_serving_days = (@next_serving - @today).to_i
		end

	end
end
