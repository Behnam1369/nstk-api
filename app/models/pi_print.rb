class PiPrint < ApplicationRecord
  has_many :pi_print_itms, foreign_key: 'IdPiPrint', dependent: :destroy
  accepts_nested_attributes_for :pi_print_itms
  belongs_to :pi_pattern, foreign_key: 'IdPiPattern'
  # belongs_to :pi, foreign_key: 'IdPi'

  self.table_name = 'PiPrint'
  self.primary_key = 'IdPiPrint'
end
