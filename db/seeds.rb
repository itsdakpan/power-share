# Demo data: hosts with listed powers, past and upcoming bookings, and reviews.
# Log in with demo@power-share.app / password123

puts "Cleaning database..."
[Review, Booking, Superpower, User].each(&:destroy_all)

puts "Creating users..."
people = {
  demo:   { first_name: "Dylan",  email: "demo@power-share.app" },
  ines:   { first_name: "Inês",   email: "ines@example.com" },
  tobias: { first_name: "Tobias", email: "tobias@example.com" },
  aoife:  { first_name: "Aoife",  email: "aoife@example.com" },
  kwame:  { first_name: "Kwame",  email: "kwame@example.com" },
  lena:   { first_name: "Lena",   email: "lena@example.com" },
  rafa:   { first_name: "Rafael", email: "rafa@example.com" }
}
users = people.transform_values { |attrs| User.create!(attrs.merge(password: "password123")) }

puts "Listing powers..."
listings = [
  [:ines,   "Flight",            "Fly up to 300m for a few hours a day. Great for sunrise views over Lisbon or getting a kite out of a tree. Not for bad weather.", 120, "Heroic"],
  [:tobias, "Super strength",    "Lift a small car without breaking a sweat. Popular for moving day and shifting a piano up three flights of stairs.", 64, "Legendary"],
  [:aoife,  "Invisibility",      "Disappear completely for up to 20 minutes at a time. Perfect for surprise parties. Please don't use it for anything dodgy.", 38, "Solid"],
  [:kwame,  "Super speed",       "Run at 90km/h in short bursts. You'll never miss the last train again.", 45.5, "Strong"],
  [:lena,   "Talk to animals",   "Have a proper conversation with dogs, cats and most birds. Pigeons are rude, you've been warned.", 14.5, "Gentle"],
  [:rafa,   "Freeze time",       "Pause everything around you for up to 60 seconds, twice a day. Ideal for exams and awkward moments.", 210, "Legendary"],
  [:ines,   "Water breathing",   "Breathe underwater for the whole day. Tested off the coast of Cornwall in October, so it handles the cold.", 29, "Solid"],
  [:tobias, "Healing touch",     "Heal cuts, bruises and hangovers with a hand on the shoulder. Doesn't work on broken hearts.", 52, "Strong"],
  [:aoife,  "Weather control",   "Bring the sun out for a barbecue or a gentle bit of rain for the garden. Local area only, roughly one postcode.", 88, "Heroic"]
]
powers = listings.map do |host, name, description, price, strength|
  Superpower.create!(user: users[host], name: name, description: description, price: price, strength: strength)
end
by_name = powers.index_by(&:name)

puts "Adding bookings and reviews..."
today = Date.current
past = [
  [:demo,  "Flight",          -40, 1, 5, "Flew over the Algarve coast at sunset. Ines gave great tips on landing."],
  [:demo,  "Invisibility",    -22, 1, 4, "Pulled off the best surprise party ever. Wore off a bit early."],
  [:kwame, "Flight",          -15, 2, 5, "Worth every penny. My daughter still talks about it."],
  [:lena,  "Super strength",  -30, 1, 5, "Moved a whole flat in an afternoon. Tobias was lovely."],
  [:rafa,  "Talk to animals", -12, 3, 4, "My cat finally explained the 3am zoomies. Not what I expected."],
  [:aoife, "Super speed",     -9,  1, 3, "Fast, but I kept overshooting my stop."]
]
past.each do |who, power, offset, days, rating, comment|
  start = today + offset
  Booking.new(user: users[who], superpower: by_name[power], start_date: start, end_date: start + (days - 1),
              comment: nil).save!(validate: false)
  Review.create!(user: users[who], superpower: by_name[power], rating: rating, comment: comment, created_at: (start + days).to_time)
end
# A past booking of the demo account's that still needs a review.
Booking.new(user: users[:demo], superpower: by_name["Water breathing"], start_date: today - 6, end_date: today - 5).save!(validate: false)

Booking.create!(user: users[:demo], superpower: by_name["Super strength"], start_date: today + 5, end_date: today + 6,
                comment: "Moving house on Saturday, two sofas and a piano.")
Booking.create!(user: users[:demo], superpower: by_name["Weather control"], start_date: today + 18, end_date: today + 18,
                comment: "Garden party, fingers crossed for sun.")

puts "Done. Log in with demo@power-share.app / password123"
