require_relative 'init'

class FirstRun

  def run
    47.times do |i|
      url = make_url(i)
      page = fetch_page(url)
      res = parse_page(page)
    end
    Deposit.where('term<1').delete_all
  end

  def make_url(page_number)
    url = "http://www.banki.ru/products/deposits/search/"\
      "Moskva/?PAGEN_1=#{page_number}&filter=0&sort_param=undefined&sort_order=undefined&"\
      "PAGESIZE=25&sum=%EB%FE%E1%E0%FF&currency=45&period=0&capitalization=2"\
      "&replenishment=1&withdrawable=2&SPECIAL_DEPOSIT%5B1%5D=2"\
      "&SPECIAL_DEPOSIT%5B2%5D=0&SPECIAL_DEPOSIT%5B7%5D=2&"\
      "SPECIAL_DEPOSIT%5B4%5D=2&SPECIAL_DEPOSIT%5B5%5D=2&"\
      "SPECIAL_DEPOSIT%5B6%5D=2&SPECIAL_DEPOSIT%5B3%5D=2&SPECIAL_DEPOSIT%5B10%5D=0"\
      "&SPECIAL_DEPOSIT%5B8%5D=2&bankShow=all&bankTop=0#nav_start"
  end

  def fetch_page(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response uri
    response.body
  end

  def parse_page(page)
    html_doc = Nokogiri::HTML(page)
    elements = html_doc.css('#search-result .t-page tr.hover')
    elements.each do |element|
      parse_element element
    end
  end

  def parse_element(e)
    deposit = Deposit.new
    # b-deposits-item__bank
    link = e.css('.t-page__sorted h3 a').first
    deposit.website_link = link['href']
    deposit.website_id=/deposit\/(\d+)\//.match(deposit.website_link)[1].to_i
    deposit.title = link.content
    deposit.bank = e.css('.t-page__sorted .b-deposits-item__bank a').first.content
    rate = e.css('.t-page__rate').first.content
    deposit.rate = rate.gsub('%','').gsub(',','.').to_f
    min = e.css('.t-page__amount').first.content
    deposit.min = min.gsub(/[^\d]/,'').to_i
    term=e.css('.t-page__term div').first['title']
    deposit.term = term.gsub(/[^\d]/,'').to_f / 365
    deposit.save
  end

end

fr = FirstRun.new
fr.run
