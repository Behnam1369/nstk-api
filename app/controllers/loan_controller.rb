class LoanController < ApplicationController
  def new
    q = "
      declare @iduser int = ?
      select cast((select 
        (select * from loanType for json auto) as LoanTypes , 
        dbo.GrossSalary(idwinkart) as GrossSalary, 
        dbo.EmploymentMonth(idwinkart) as EmploymentMonth,
        dbo.HierarchyLevel(iduser) as HierarchyLevel,
        dbo.ActiveMonthlyInstallments(idwinkart) as ActiveMonthlyInstallments,
        fname + ' ' + lname as FullName , 
        IdWinkart as PerNo
        from users where iduser = @iduser for json path, include_null_values) as nvarchar(max)) as data
    "

    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([q, params[:iduser]])
    )

    render json: data
  end

  def create
    @loan = Loan.new(loan_params)
    puts @loan.inspect
    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def loan_params
    params.require(:loan).permit(
      :IdLoan,
      :IdUser,
      :FullName,
      :PerNo,
      :IdLoanType,
      :LoanType,
      :Step,
      :State,
      :RequestDate,
      :RequestDateShamsi,
      :Amount,
      :Installments,
      :InstallmentAmount,
      :InstallmentFirstMonth,
      :InstallmentLastMonth,
      :IdFiles,
      :Note,
      :IdManager,
      :Manager,
      :ManagerNote,
      :ManagerConfirmDate,
      :ManagerConfirmDateShamsi,
      :IdHr,
      :Hr,
      :HrNote,
      :HrConfirmDate,
      :HrConfirmDateShamsi
    )
  end

end