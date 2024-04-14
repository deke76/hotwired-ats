class Email < ApplicationRecord
  has_rich_text :body
  
  belongs_to :applicant
  belongs_to :user
end
