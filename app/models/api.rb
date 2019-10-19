class API
	def self.logDay(date)
		url = URI.parse('https://umassdining.com/foodpro-menu-ajax?tid=1&date=' + date.mon.to_s + '%2F' + date.mday.to_s + '%2F' + date.year.to_s)
		req = Net::HTTP::Get.new(url.to_s)
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		res = http.request(req)
		data = JSON.parse res.body

		meals = []
		data.each do |meal, stations|
			stations.each do |station, data|
				lunch = data.to_s
				while lunch.include? "data-dish-name="
					keyword = "data-dish-name=\""
					ind = lunch.index(keyword)
					lunch = lunch[(ind+keyword.length)..-1]
					indEnd = lunch.index("\"")

					mealName = lunch[0..indEnd-1]
					if Dish.where(name: mealName, meal: meal, date: date).size < 1
						Dish.create(name: mealName, meal: meal, date: date, day: date.strftime("%A").downcase)
					end
					meals.append(mealName)
				end
			end
		end

		puts date.to_s + " Logged"

		return meals
	end
end