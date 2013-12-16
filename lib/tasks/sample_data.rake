namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
    make_swaps
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar123",
                       password_confirmation: "foobar123",
                       )
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

def make_swaps
  users = User.all(limit: 3)
  50.times do
    description = Faker::Lorem.sentence(5)
    offer = Faker::Lorem.sentence(10)
    want = Faker::Lorem.sentence(4)
    place = "Olivos, Buenos Aires, Argentina"
    tag_list = Faker::Lorem.words(1).to_s + ', ' + Faker::Lorem.words(1).to_s
    users.each { |user| user.swaps.create!(description: description, 
                    offer: offer, want: want, tag_list: tag_list) }
  end
end
