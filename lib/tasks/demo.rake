namespace :demo do
  desc "Wipe everything and load the demo groups, check-ins and comments again"
  task reset: :environment do
    load Rails.root.join("db/seeds.rb")
  end

  desc "Load demo data only if the database has no users yet (used on first deploy)"
  task seed_if_empty: :environment do
    if User.none?
      load Rails.root.join("db/seeds.rb")
    else
      puts "Users already exist, skipping demo seed."
    end
  end
end
