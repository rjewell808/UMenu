require 'net/http'

class MainController < ApplicationController
	def home
		url = URI.parse('https://umassdining.com/foodpro-menu-ajax?tid=1&date=10%2F20%2F2019')
		req = Net::HTTP::Get.new(url.to_s)
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		res = http.request(req)
		data = JSON.parse res.body

		meals = []
		data['lunch'].each do |station, data|
			lunch = data.to_s
			puts lunch
			while lunch.include? "data-dish-name="
				keyword = "data-dish-name=\""
				ind = lunch.index(keyword)
				lunch = lunch[(ind+keyword.length)..-1]
				indEnd = lunch.index("\"")

				meal = lunch[0..indEnd-1]
				if Dish.where(name: meal, meal: "lunch", date: Date.today).size < 1
					Dish.create(name: meal, meal: "lunch", date: Date.today, day: Date.today.strftime("%A").downcase)
				end
				meals.append(meal)
			end
		end

		puts meals
	end
end
