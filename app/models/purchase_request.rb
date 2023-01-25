class PurchaseRequest < ApplicationRecord
  has_many :purchase_request_itms, foreign_key: 'IdPurchaseRequest', dependent: :destroy
  accepts_nested_attributes_for :purchase_request_itms

  self.table_name = 'PurchaseRequest'
  self.primary_key = 'IdPurchaseRequest'
end
