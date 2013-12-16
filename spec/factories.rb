FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar123"
    password_confirmation "foobar123"

    factory :admin do
    	admin true
    end
  end

  factory :micropost do
  	content "Lorem ipsum"
  	user #we tell Factory Girl about the micropost's associated user
  end

  factory :swap do 
    description "Lorem ipsum"
    offer "habemus papam"
    want "Francesco de Asici"
    place "Paris"
    tag_list "guitarra, piano, viaje"
    user
  end
end