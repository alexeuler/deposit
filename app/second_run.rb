require_relative 'init'

class SecondRun
  def run
    deposits = Deposit.where(refill_status: nil).all.to_a
    i=0
    count = Deposit.count
    deposits.each do |deposit|
      puts "Processed #{i.to_f / count}%"
      url = "https://www.banki.ru"+deposit.website_link
      page = fetch_page(url)
      parse_page(page, deposit)
      i+=1
    end
  end

  def fetch_page(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response uri
    response.body
  end

  def parse_page(page, deposit)
    html_doc = Nokogiri::HTML(page)
    rows = html_doc.css('.standard-table--list tr')
    rows.each do |row|
      header = row.css('th').first.content if row.css('th').first
      if header == 'Пополнение'
        deposit.refill_status = row.css('td>p').first.content if row.css('td>p').first
        deposit.refill_warning = row.css('.notice--warning p').first.content if row.css('.notice--warning p').first
        deposit.refill_message = row.css('.notice--info').first.content if row.css('.notice--info').first
      end
    end
    deposit.save
  end

end

sr = SecondRun.new
sr.run