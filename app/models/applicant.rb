class Applicant < ApplicationRecord
  include PgSearch::Model

  validates_presence_of :first_name, :last_name, :email
  has_one_attached :resume
  belongs_to :job

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

  pg_search_scope :text_search,
    against: %i[first_name last_name email],
    using: {
      tsearch: {
        any_word: true,
        prefix: true
      }
    }

  FILTER_PARAMS = %i[query job sort].freeze

  scope :search, ->(query) { query.present? ? text_search(query) : all }
  scope :for_job, ->(job_id) { job_id.present? ? where(job_id: job_id) : all }
  scope :sorted, ->(selection) { selection.present? ? apply_sort(selection) : all }
  scope :for_account, ->(account_id) { where(jobs: { account_id: account_id }) }

  def self.apply_sort(selection)
    sort, direction = selection.split('-')
    order("applicants.#{sort} #{direction}")
  end

  def self.filter(filters)
    includes(:job)
      .search(filters['query'])
      .for_job(filters['job'])
      .sorted(filters['sort'])
  end
end
