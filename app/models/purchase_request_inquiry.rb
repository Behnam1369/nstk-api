class PurchaseRequestInquiry < ApplicationRecord
  belongs_to :purchase_request, foreign_key: 'IdPurchaseRequest', optional: true

  self.table_name = 'PurchaseRequestInquiry'
  self.primary_key = 'IdPurchaseRequestInquiry'
end
