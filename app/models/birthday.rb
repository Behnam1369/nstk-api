class Birthday < ActiveRecord::Base
  self.table_name = 'BirthDay'
  self.primary_key = 'IdBirthDay'
end