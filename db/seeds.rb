# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#random maximums

max_random_jobs = 20
max_random_people = 10

def generate_resume_with_faker(applicant, job)
  address = Faker::Address.full_address
  name = applicant.name
  email = applicant.email
  phone = applicant.phone
  job_title = job.title
  company = Account.find(job.account_id).name
  num_jobs = rand(1..5)
  
  resume = "#{name}\n"
  resume += "Email: #{email}\n"
  resume += "Phone: #{phone}\n"
  resume += "#{address}\n"
  resume += "Objective: To fill the #{job_title} role at #{company}\n\n"
  
  resume += "Experience\n"
  end_year = 2024
  num_jobs.times do |job_number|
    company = Faker::Company.name
    years = rand(1..10)
    resume += "#{company} - "
    resume += "#{job_title}: "
    start_year = end_year - rand(0..years)
    resume += "#{start_year} - #{end_year}\n"
    end_year = start_year
    
    # Generate a Faker job description
    resume += "#{Faker::Job.position.capitalize + ': ' + '. ' + Faker::Job.title.capitalize + '.'}"
    resume += "\t#{Faker::Lorem.paragraph(sentence_count: 3, random_sentences_to_add: 3)}\n"
    
    # Generate 2 or 3 random achievements
    selected_achievements = []
    rand(2..5).times { selected_achievements << Faker::Company.bs }
    
    selected_achievements.each_with_index do |achievement, index|
      resume += "\t\t*\t#{achievement}\n"
    end
    
    resume += "\n\n"
  end
  
  resume += "Education\n"
  resume += "#{Faker::Educator.university}\n"
  start_year = end_year - 4;
  resume += "#{Faker::Educator.degree}\n"
  resume += "#{start_year} - #{end_year}\n"
  resume += "\t#{Faker::Lorem.paragraph(sentence_count: 3, random_sentences_to_add: 3)}\n"
  return resume
end

def string_to_pdf(content, filename)
  Prawn::Document.generate(filename) do
    text content
  end
end

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

#create descriptions and applicants for jobs
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
    applicant = Applicant.create(
      first_name: first,
      last_name: last,
      email: Faker::Internet.email(name: "#{first}.#{last}"),
      phone: Faker::PhoneNumber.phone_number,
      stage: stage[Random.rand(stage.length)],
      status: status[Random.rand(status.length)],
      job_id: job.id
    )

    #create resume for applicant
    resume = generate_resume_with_faker(applicant, job)
    filename = "#{applicant.id}_resume.pdf"
    file = Rails.root.join("db/resumes/#{filename}")
    pdf_resume = string_to_pdf(resume, file)
    applicant.resume.attach( 
      io: File.open(file),
      filename: filename
    )
  end
end
