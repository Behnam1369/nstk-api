require 'selenium-webdriver'
require_relative '../test_helper'

save_command = "
    declare @date date = ?
    declare @shamsi_date nvarchar(10) = ?
    declare @abr nvarchar(50) = ?
    declare @rate float = ? 
    declare @title nvarchar(max) = ?
    if(exists(select * from exchangerates where abr = @abr and date=@date and title= @title))
    begin
        update exchangerates set rate = @rate where abr = @abr and date=@date
    end
    else
    begin
        insert into exchangerates (idexchangerate, date, dateshamsi, abr, title, rate, source )
        values (
            (select isnull(max(idexchangerate),0)+1 from exchangerates) , 
            @date , 
            @shamsi_date , 
            @abr , 
            @title ,
            @rate , 
            'sanarate'
        )
    end
  "

RSpec.describe 'Get Sana Rates' do
  include ShamsiDateHelper
  it 'getting rates ...' do
    driver = Selenium::WebDriver.for :chrome
    driver.get('http://www.sanarate.ir/')
    driver.manage.timeouts.implicit_wait = 500
    # date = DateTime.now
    date = Date.new(2018,9,25)
    puts date
    puts date > Date.new(2012,1,1)

    while date > Date.new(2012,1,1) do
      text_box = driver.find_element(id: 'MainContent_ViewCashChequeRates_txtDate')
      submit_button = driver.find_element(id: 'MainContent_ViewCashChequeRates_Button1')
     
      text_box.clear
      shamsi_date = shamsi_date(date) 
      text_box.send_keys(shamsi_date)
      submit_button.click

      message = driver.find_element(id: 'MainContent_ViewCashChequeRates_spnMessage').text 
      if message == ""
        table = driver.find_element(css: 'table.table' )
        thead = table.find_element(tag_name: 'thead')
        columns = thead.find_elements(tag_name: 'span').map { |column| column.text }
        
        rows = table.find_element(tag_name: 'tbody').find_elements(tag_name: 'tr')
        rows.each{|row|
          cells = row.find_elements(tag_name: 'td')
          currency = ''
          cells.each_with_index { |cell, i| 
            currency = cell.text if i == 1
            if i > 1 && cell.text != '--'
              puts " getting #{currency} rates at #{shamsi_date(date)} ... "
              
              ActiveRecord::Base.connection.execute(
                ApplicationRecord.sanitize_sql([save_command, 
                  date, shamsi_date , 
                  currency, 
                  cell.text.gsub(',',''), 
                  columns[i].gsub('*','')
                ])
              )
            end
          }
        }
      end
      date = date - 1
    end
  end
end