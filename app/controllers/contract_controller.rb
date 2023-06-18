class ContractController < ApplicationController
  def new
    # depts including title method
    depts = Dept.includes(:dl).map { |dept| dept.attributes.merge(dept.dl.attributes) }
    render json: {depts: depts  }
  end

  def show 
    @contract = Contract.find(params[:idcontract])
  
    # depts including title
    depts = Dept.includes(:dl).map { |dept| dept.attributes.merge(dept.dl.attributes) }
    render json: {contract: @contract, depts: depts }
  end
  
  def create 
    puts contract_params
    @contract = Contract.new(contract_params)
    user = User.find(params[:iduser])
    @contract.user = user
    @contract.Issuer = user.full_name
    
    if (params[:autoGenerate] == true)
      shamsi_year = params[:ContractDateShamsi][0..3]
      no = Contract.where("Left(ContractDateShamsi, 4) = ? and No > 0 and isnull(state, 0) = 0", shamsi_year).maximum(:No).to_i + 1
      @contract.No = no
      @contract.ContractNo = "#{params[:HeadLetter]}-#{Dept.find(params[:IdDept])[:Abr]}-CON-#{shamsi_year[1..3]}#{("00" + no.to_s)[-2..-1]}"
    end

    if @contract.save
      render json: @contract
    else
      render json: @contract.errors, status: :unprocessable_entity
    end
  end

  def update
    @contract = Contract.find(params[:idcontract])
    if @contract.update(contract_params)
      render json: @contract
    else
      render json: @contract.errors, status: :unprocessable_entity
    end
  end

  def cancel
    @contract = Contract.find(params[:idcontract])
    @contract.State = 1
    if @contract.save
      render json: @contract
    else
      render json: @contract.errors, status: :unprocessable_entity
    end
  end

  def recover
    @contract = Contract.find(params[:idcontract])
    @contract.State = nil
    if @contract.save
      render json: @contract
    else
      render json: @contract.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @contract = Contract.find(params[:idcontract])
    @contract.State = -1
    if @contract.save
      render json: @contract
    else
      render json: @contract.errors, status: :unprocessable_entity
    end
  end

  def contract_params
    params.require(:contract).permit(
      :HeadLetter,
      :IdDept,
      :Dept,
      :ContractDate,
      :ContractDateShamsi,
      :No,
      :ContractNo,
      :Contractor,
      :Subject,
      :Note,
      :IdFiles,
      :IdUser,
      :Issuer,
      :State,
      :autoGenerate
    )
  end
end