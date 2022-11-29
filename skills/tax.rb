# Develop a tax calculator, accepts an amount and calculates the total , vat, nhil, covid levy inclusive

require 'open-uri'
require 'json'

class CalculateTax

    def calculate(amount)
        nhil = 0.025 * amount
        covid_levy = 0.01 * amount
        sub_total = amount + nhil + covid_levy
        vat = 0.125 * sub_total
        total = sub_total + vat
        fini = "NHIL : #{nhil}\n COVID Levy : #{covid_levy}\n Sub-Total: #{sub_total}\n VAT: #{vat}\n **Total: #{total}**"
        fini
    end
    
end



