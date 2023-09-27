class VoyageDateController < ApplicationController
  def get_voyage_date_items
    idvoyage = params["idvoyage"] || 0
    eta = params["eta"] == "0" ? DateTime.now.strftime("%Y-%m-%d") : params["eta"]
    idcontract = params["idcontract"] || 0
    voyageno = params["voyageno"] || 0

    sql = " exec GetVoyageDates '#{eta}', #{idvoyage} , #{idcontract} , #{voyageno} "
    result = ActiveRecord::Base.connection.select_all(sql)[0]["Result"]
    render json: result
  end

  def get_voyages_dates
    sql = " exec GetVoyagesDates"
    result = ActiveRecord::Base.connection.select_all(sql)[0]["Result"]
    render json: result
  end

  def register
    idvoyagedateitem = params["idVoyageDateItem"]
    idvoyage = params["idvoyage"]
    idcontract = params["idcontract"]
    voyageno = params["voyageno"]
    iduser = params["iduser"]
    eta = params["eta"] == "0" ? DateTime.now.strftime("%Y-%m-%d") : params["eta"]

    sql = "
      exec RegisterVoyageDate #{idvoyagedateitem}, #{idvoyage}, #{idcontract}, #{voyageno}, #{iduser} 
      exec GetVoyageDates '#{eta}' , #{idvoyage} , #{idcontract}, #{voyageno}
    "
    result = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([sql, idvoyage, idcontract, voyageno])
    )[0]["Result"]
    render json: result
  end

  def clear
    idvoyagedateitem = params["idVoyageDateItem"]
    puts idvoyagedateitem
    idvoyage = params["idvoyage"]
    idcontract = params["idcontract"]
    voyageno = params["voyageno"]
    iduser = params["iduser"]
    eta = params["eta"] == "0" ? DateTime.now.strftime("%Y-%m-%d") : params["eta"]

    sql = "
      exec ClearVoyageDate #{idvoyagedateitem}, #{idvoyage}, #{idcontract}, #{voyageno}, #{iduser} 
      exec GetVoyageDates '#{eta}', #{idvoyage} , #{idcontract}, #{voyageno}
    "
    result = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([sql, idvoyage, idcontract, voyageno])
    )[0]["Result"]
    render json: result
  end

  def increment
    idvoyagedateitem = params["idVoyageDateItem"]
    idvoyage = params["idvoyage"]
    idcontract = params["idcontract"]
    voyageno = params["voyageno"]
    iduser = params["iduser"]
    eta = params["eta"] == "0" ? DateTime.now.strftime("%Y-%m-%d") : params["eta"]

    sql = "
      exec IncrementVoyageDate #{idvoyagedateitem}, #{idvoyage}, #{idcontract}, #{voyageno}, #{iduser} 
      exec GetVoyageDates '#{eta}', #{idvoyage} , #{idcontract}, #{voyageno}
    "
    result = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([sql, idvoyage, idcontract, voyageno])
    )[0]["Result"]
    render json: result
  end

  def decrement
    idvoyagedateitem = params["idVoyageDateItem"]
    idvoyage = params["idvoyage"]
    idcontract = params["idcontract"]
    voyageno = params["voyageno"]
    iduser = params["iduser"]
    eta = params["eta"] == "0" ? DateTime.now.strftime("%Y-%m-%d") : params["eta"]

    sql = "
      exec DecrementVoyageDate #{idvoyagedateitem}, #{idvoyage}, #{idcontract}, #{voyageno}, #{iduser} 
      exec GetVoyageDates '#{eta}', #{idvoyage} , #{idcontract}, #{voyageno}
    "
    result = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([sql, idvoyage, idcontract, voyageno])
    )[0]["Result"]
    render json: result
  end

end