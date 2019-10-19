class API
	def self.logDay(date)
		url = URI.parse('https://umassdining.com/foodpro-menu-ajax?tid=1&date=' + date.mon.to_s + '%2F' + date.mday.to_s + '%2F' + date.year.to_s)
		req = Net::HTTP::Get.new(url.to_s)
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		res = http.request(req)
		data = JSON.parse res.body

		meals = []
		keyword = "data-dish-name=\""
		data.each do |meal, stations|
			if meal == "grabngo"
				next
			end
			stations.each do |station, data|
				lunch = data.to_s
				while lunch.include? keyword
					indStart = lunch.index(keyword) + keyword.length
					indEnd = lunch.index("\"", indStart) - 1

					mealName = lunch[indStart..indEnd]

					if !mealName.blank?
						if Dish.where(name: mealName, meal: meal, date: date).size < 1
							Dish.create(name: mealName, meal: meal, date: date, day: date.strftime("%A").downcase)
						end
						meals.append(mealName)
					end

					lunch = lunch[indEnd..-1]
				end
			end
		end

		puts date.to_s + " Logged"

		return meals
	end
end