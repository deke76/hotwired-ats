class Applicant < ApplicationRecord
  include PgSearch::Model
  validates_presence_of :first_name, :last_name, :email
  has_one_attached :resume
  belongs_to :job

  pg_search_scope :text_search,
    against: %i[first_name last_name email],
    using: {
      tsearch: {
        any_word: true,
        prefix: true
      }
    }

  enum stage: {
    application: 'application',
    interview: 'interview',
    offer: 'offer',
    hired: 'hired',
  }

  enum status: {
    active: 'active',
    inactive: 'inactive',
  }


  def name
    [first_name, last_name].join(' ')
  end
end
