class API
	def self.logDay(date)
		url = URI.parse('https://umassdining.com/foodpro-menu-ajax?tid=1&date=' + date.mon.to_s + '%2F' + date.mday.to_s + '%2F' + date.year.to_s)
		req = Net::HTTP::Get.new(url.to_s)
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		res = http.request(req)
		data = JSON.parse res.body

		meals = []
		keywords = ["data-allergens=\"", "data-clean-diet-str=\"", "data-serving-size=\"", "data-calories=\"", "data-total-fat=\"", "data-total-fat-dv=\"", "data-sat-fat=\"", "data-sat-fat-dv=\"", "data-trans-fat=\"", "data-cholesterol=\"", "data-cholesterol_dv=\"", "data-sodium=\"", "data-sodium-dv=\"", "data-total-carb=\"", "data-total-carb-dv=\"", "data-dietary-fiber=\"", "data-dietary-fiber-dv=\"", "data-sugars=\"", "data-sugars-dv=\"", "data-protein=\"", "data-protein-dv=\"", "data-dish-name=\""]
		main_keyword = "data-dish-name=\""
		data.each do |meal, stations|
			if meal == "grabngo"
				next
			end
			stations.each do |station, data|
				lunch = data.to_s
				while lunch.include? main_keyword
					values = {}
					keywords.each do |keyword|
						indStart = lunch.index(keyword) + keyword.length
						indEnd = lunch.index("\"", indStart) - 1
						valueStr = lunch[indStart..indEnd]
						values[keyword] = valueStr
						lunch = lunch[indEnd..-1]
					end

					if !Food.exists?(name: values["data-dish-name=\""])
						Food.create(
							name: values["data-dish-name=\""], 
							allergens: values["data-allergens=\""],
							diet: values["data-clean-diet-str=\""],
							serving: values["data-serving-size=\""],
							calories: values["data-calories=\""],
							fat: values["data-total-fat=\""],
							fat_dv: values["data-total-fat-dv=\""],
							sat_fat: values["data-sat-fat=\""],
							sat_fat_dv: values["data-sat-fat-dv=\""],
							trans_fat: values["data-trans-fat=\""],
							cholestrol: values["data-cholesterol=\""],
							cholestrol_dv: values["data-cholesterol_dv=\""],
							sodium: values["data-sodium=\""],
							sodium_dv: values["data-sodium-dv=\""],
							total_carb: values["data-total-carb=\""],
							total_carb_dv: values["data-total-carb-dv=\""],
							dietary_fiber: values["data-dietary-fiber=\""],
							dietary_fiber_dv: values["data-dietary-fiber-dv=\""],
							sugars: values["data-sugars=\""],
							sugars_dv: values["data-sugars-dv=\""],
							protein: values["data-protein=\""],
							protein_dv: values["data-protein-dv=\""])
					end
					Dish.create(food_id: Food.find_by(name: values["data-dish-name=\""]).id, meal: meal, date: date, day: date.strftime("%A").downcase)
				end
			end
		end

		puts date.to_s + " Logged"

		return meals
	end
end