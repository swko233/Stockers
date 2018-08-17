# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times do |n|
	email = 'seed' + n + '@gmail.com'
	user_name = 'user' + n
	nickname = Faker::Overwatch.hero
	image_number = rand(6..10)
	User.create!(email: email,
				password: '000000',
				name: user_name,
				nickname: nickname,
				product_image_name: File.open("./app/assets/images/#{image_number}.jpg")
				)
end