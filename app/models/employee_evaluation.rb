class EmployeeEvaluation < ApplicationRecord
  has_many :employee_evaluation_users, foreign_key: 'IdEmployeeEvaluation'

  self.table_name = 'EmployeeEvaluation'
  self.primary_key = 'IdEmployeeEvaluation'

  def related_users(user)
    list = []
    self.employee_evaluation_users.each do |eeu|
      User.find(94)
      if eeu.IdManager == user.IdUser || eeu.IdManager0 == user.IdUser || eeu.IdUser == user.IdUser
        employee = User.find(eeu.IdUser)
        manager0 = User.find(eeu.IdManager0) if eeu.IdManager0
        list << eeu.attributes.merge({ FullName: employee.full_name, ManagerName0: manager0 ? manager0.full_name : nil })
      end      
    end
    list
  end
end
