# frozen_string_literal: true
module ExamplePhoneMacros
  def generate_random_name
    "#{ Faker::Name.first_name } #{ Faker::Name.last_name }"
  end
end
