# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#random maximums

max_random_jobs = 10
max_random_people = 5

#create accounts
puts "Creating accounts"
accounts = ["Avnet", "TTI Inc", "Arrow Electronics"]
accounts.each do |account|
  Account.create(name: account)
end

#create users for each account
puts "Creating users for each account"
Account.all.each do |account|
  #create a random number of users for each account
  number_of_users = Random.rand(max_random_people)
  number_of_users.times do |user|
    first = Faker::Name.first_name
    last = Faker::Name.last_name
    sign_up_params = {
      first_name: first,
      last_name: last,
      email: "#{[first, last].join(".")}@#{account.name.gsub(/\s+/, "").downcase}.com",
      password: "password",
      account_id: account.id
    }
    User.create(sign_up_params)
  end
end

family = ["Nadia", "Darcy", "Makenna"]
family.each_with_index do |user, index|
  id = Account.find_by(name: accounts[index]).id
  sign_up_params = {
    first_name: user,
    last_name: "Lauder",
    email: "#{[user, "Lauder"].join(".")}@shaw.ca",
    password: "password",
    account_id: id
  }
  User.create(sign_up_params)
end

# #create random jobs
puts "Creating random jobs"
status = ['draft', 'open','closed',]
job_type = ['full_time', 'part_time']
users = User.all
users.each do |user|
  number_of_jobs = Random.rand(max_random_jobs)
  number_of_jobs.times do |job|
    job_params = {
      title: Faker::Job.title,
      location: Faker::Address.city,
      status: status[Random.rand(status.length)],
      job_type: job_type[Random.rand(status.length)],
      account_id: user.account_id
    }
    Job.create(job_params)
  end
end

#   #create descriptions and applicants for jobs
puts "Creating descriptions & applicants for jobs"
stage = ['application', 'interview', 'offer', 'hired']
status = ['active', 'inactive']
jobs = Job.all
jobs.each do |job|
  #create description
  body_text = "#{Faker::HTML.heading}<div>#{Faker::HTML.paragraph}</div>"
  ActionText::RichText.create(
    name: "description", 
    body: body_text,
    record_type: "Job",
    record_id: job.id,
  )
  #create applicants for jobs
  number_of_applicants = Random.rand(max_random_people)
  number_of_applicants.times do |applicant|
    first = Faker::Name.first_name
    last = Faker::Name.last_name
    Applicant.create(
      first_name: first,
      last_name: last,
      email: Faker::Internet.email(name: "#{first}.#{last}"),
      phone: Faker::PhoneNumber.phone_number,
      stage: stage[Random.rand(stage.length)],
      status: status[Random.rand(status.length)],
      job_id: job.id
    )
  end
end
