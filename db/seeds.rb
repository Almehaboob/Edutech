# Create an admin user
# User.create!(email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com')

# Seed Courses

30.times do
  Course.create!({
    title: Faker::Educator.course_name,
    description: Faker::JapaneseMedia::OnePiece.quote,
    short_description: Faker::Lorem.sentence(word_count: 10),
    languaes: Faker::Lorem.words(number: 2).join(", "),
    level: Faker::Educator.degree,
    price: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    user_id: User.first.id
  })

end