class PiPatternItm < ApplicationRecord
  belongs_to :pi_pattern, foreign_key: 'IdPiPattern', optional: true

  self.table_name = 'PiPatternItm'
  self.primary_key = 'IdPiPatternItm'
end
