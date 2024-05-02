class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: :commentable_count

  has_rich_text :comment
end