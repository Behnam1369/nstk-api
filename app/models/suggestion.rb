class Suggestion < ApplicationRecord
  belongs_to :dept, foreign_key: :IdDept
  belongs_to :user, foreign_key: :IdUser
  has_many :suggestion_comments, foreign_key: :IdSuggestion

  self.table_name = 'Suggestion'
  self.primary_key = 'IdSuggestion'
end
