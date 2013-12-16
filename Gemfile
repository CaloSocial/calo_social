source 'https://rubygems.org'
ruby '2.0.0'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.0.0'

gem 'bootstrap-sass', '2.3.2.0' #bootstrap uses Less CSS by default,
                                #this gem converts it to sass
gem 'bcrypt-ruby', '3.0.1' #irreversibly encript pass to pasword hash
# to create fake users:
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'
#Tags:
gem 'acts-as-taggable-on', '2.4.1'
#Geolocalization:
gem 'geocoder', '1.1.8'
#Searching:
gem 'ransack', '1.1.0'
#Omniauth:
gem 'omniauth-facebook'
gem 'omniauth'
gem 'twitter'
gem 'devise'
gem 'fb_graph'
#envVars:
gem 'figaro', '0.7.0'
#simple form
gem 'simple_form'

group :development, :test do
  gem 'sqlite3', '1.3.7'
  gem 'rspec-rails', '2.13.1'
  gem 'guard-rspec', '2.5.0'
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'
  #format to rspec
  gem 'fuubar'
  #Error if test start with should
  gem 'should_not', '1.0.0'
  #Clean should in specs
  gem 'should_clean', '0.0.3'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.2.1'
  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
end

gem 'sass-rails', '4.0.0'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.0'
gem 'jquery-rails', '3.0.4'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end
