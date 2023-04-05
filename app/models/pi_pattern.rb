class PiPattern < ApplicationRecord
  has_many :pi_pattern_itms, foreign_key: 'IdPiPattern', dependent: :destroy
  accepts_nested_attributes_for :pi_pattern_itms

  self.table_name = 'PiPattern'
  self.primary_key = 'IdPiPattern'
end
