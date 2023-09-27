class VoyageDate < ApplicationRecord
  belongs_to :voyage_date_item, foreign_key: :IdVoyageDateItem

  self.table_name = 'VoyageDate'
  self.primary_key = 'IdVoyageDate'
end
