require 'date'

module ShamsiDateHelper
  def shamsi_date(gdt)
    
    if !gdt.instance_of? String
      gdt = gdt.strftime('%Y-%m-%d')
    end

    res = ""
    unless gdt.empty?
      g_days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
      j_days_in_month = [31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29]
      jalali = []

      gy = gdt[0, 4].to_i - 1600
      gm = gdt[5, 2].to_i - 1
      gd = gdt[8, 2].to_i - 1

      g_day_no = 365 * gy + (gy + 3) / 4 - (gy + 99) / 100 + (gy + 399) / 400

      (0...gm).each { |i| g_day_no += g_days_in_month[i] }
      if gm > 1 && ((gy % 4 == 0 && gy % 100 != 0) || gy % 400 == 0)
        g_day_no += 1 # leap and after Feb
      end
      g_day_no += gd

      j_day_no = g_day_no - 79

      j_np = j_day_no / 12053 # 12053 = 365*33 + 32/4
      j_day_no %= 12053

      jy = 979 + 33 * j_np + 4 * (j_day_no / 1461) # 1461 = 365*4 + 4/4

      j_day_no %= 1461

      if j_day_no >= 366
        jy += (j_day_no - 1) / 365
        j_day_no = (j_day_no - 1) % 365
      end

      i = 0
      while i < 11 && j_day_no >= j_days_in_month[i]
        j_day_no -= j_days_in_month[i]
        i += 1
      end

      jm = i + 1
      jd = j_day_no + 1
      jalali[0] = jy
      jalali[1] = jm
      jalali[2] = jd

      res = "#{jy}/#{jm}/#{jd}"
      z = res.split("/")
      res = "#{z[0]}/#{z[1].rjust(2, '0')}/#{z[2].rjust(2, '0')}"
    end

    res
  end
end