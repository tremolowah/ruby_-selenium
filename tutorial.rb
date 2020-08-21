require "selenium-webdriver"
require "csv"

# 事前準備
# https://sites.google.com/a/chromium.org/chromedriver/downloads

# チュートリアル1 – driverを宣言する
@d = Selenium::WebDriver.for :chrome
sleep 3
@d.get("https://katsulog.tech/")

def tutorial2
  p "チュートリアル2 – URLにアクセスして表示させる"
  @d.get("https://katsulog.tech/")
  # またはd.navigate.to("https://katsulog.tech/")
  sleep 3

  p "演習"
  @d.get("https://google.co.jp")
  sleep 3

  @d.get("https://www.yahoo.co.jp/")
  sleep 3
end

def tutorial3
  p "チュートリアル3 – セレクターを指定して要素にアクセスする"
  @d.get("https://katsulog.tech/")
  sleep 3

  puts @d.find_element(:id, "post-224").text
  sleep 3

  puts @d.find_elements(:class, "post").count
  sleep 3

  p "演習"
  puts @d.find_element(:id, "post-213").text
  sleep 3
end

def tutorial4
  p "チュートリアル – 4 要素の継承"
  puts @d.find_element(:id, "post-224").find_element(:tag_name, "h2").text
  sleep 3

  p "演習"
  puts @d.find_element(:id, "post-224").find_element(:tag_name, "p").text
  sleep 3
end

def tutorial5
  p "チュートリアル5 – 属性へのアクセス"
  puts @d.find_element(:id, "post-224").find_element(:tag_name, "h2").find_element(:tag_name, "a").attribute("href")
  # これでもいけます。
  # puts d.find_element(:id, 'post-224').find_element(:tag_name, 'a').attribute("href")
  sleep 3

  # 演習
  puts d.find_element(:id, "post-224").attribute("class")
  sleep 3
end

def tutorial6
  p "チュートリアル6 – 配列で回す"
  @d.find_elements(:class, "post").each do |post|
    puts post.find_element(:tag_name, "h2").text
  end
  sleep 3

  urls = []
  @d.find_elements(:class, "post").each do |post|
    # チュートリアル7 – デバック
    #require "debug"
    urls << post.find_element(:tag_name, "h2").find_element(:tag_name, "a").attribute("href")
  end

  urls.each do |url|
    #演習
    require "debug"
    puts url
  end
  sleep 3

  # 演習
  titles = []
  @d.find_elements(:class, "post").each do |post|
    titles << post.find_element(:tag_name, "h2").text
  end

  titles.each do |title|
    puts title
  end
  sleep 3
end

def tutorial8
  p "チュートリアル8 – ページャの移動"
  urls = []
  @d.find_elements(:class, "post").each do |post|
    urls << post.find_element(:tag_name, "h2").find_element(:tag_name, "a").attribute("href")
  end

  # @d.find_element(:class, "next page-numbers").click
  @d.find_element(:xpath, '//*[@id="main"]/nav/div/a[2]').click

  sleep 4

  p "演習"
  urls = []
  @d.find_elements(:class, "post").each do |post|
    urls << post.find_element(:tag_name, "h2").find_element(:tag_name, "a").attribute("href")
  end

  urls.each do |url|
    puts url
  end
end

def tutorial9
  p "チュートリアル9 – ループとブレイク"
  urls = []
  loop do
    @d.find_elements(:class, "post").each do |post|
      urls << post.find_element(:tag_name, "h2").find_element(:tag_name, "a").attribute("href")
    end

    if @d.find_elements(:xpath, '//*[@class="next page-numbers"]').size > 0
      @d.find_element(:xpath, '//*[@class="next page-numbers"]').click
    else
      break
    end
  end

  urls.each do |url|
    puts url
  end
  sleep 3
end

def tutorial10
  p "チュートリアル10 – 各ページへのアクセス"
  urls = []
  loop do
    @d.find_elements(:class, "post").each do |post|
      urls << post.find_element(:tag_name, "h2").find_element(:tag_name, "a").attribute("href")
    end

    if @d.find_elements(:xpath, '//*[@class="next page-numbers"]').size > 0
      @d.find_element(:xpath, '//*[@class="next page-numbers"]').click
    else
      break
    end
  end

  urls.each do |url|
    @d.get(url)
  end
  sleep 3
end

def tutorial11
  p "チュートリアル11 – waitの設定"
  wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  @d.get("https://katsulog.tech/")

  urls = []
  loop do
    wait.until { @d.find_elements(:class, "post").size > 0 }
    @d.find_elements(:class, "post").each do |post|
      urls << post.find_element(:tag_name, "h2").find_element(:tag_name, "a").attribute("href")
    end

    p "演習"
    if @d.find_elements(:xpath, '//*[@class="next page-numbers"]').size > 0
      wait.until { @d.find_element(:xpath, '//*[@class="next page-numbers"]').displayed? }
      @d.find_element(:xpath, '//*[@class="next page-numbers"]').click
    else
      break
    end
  end

  urls.each do |url|
    @d.get(url)
  end
  sleep 3
end

def tutorial12
  p "チュートリアル12 – CSVに書き出す"
  bom = %w(EF BB BF).map { |e| e.hex.chr }.join
  csv_file = CSV.generate(bom) do |csv|
    csv << ["No", "Title", "URL"]
  end

  File.open("result.csv", "w") do |file|
    file.write(csv_file)
  end
end

def tutorial12_2
  p "チュートリアル12 – CSVに書き出す"
  bom = %w(EF BB BF).map { |e| e.hex.chr }.join
  csv_file = CSV.generate(bom) do |csv|
    # csv << ["No", "Title", "URL"]
    # 演習
    csv << ["No", "Title", "URL", "selenium"]
  end

  #  File.open("result.csv", "w") do |file|
  File.open("result_ensyu.csv", "w") do |file|
    file.write(csv_file)
  end

  @d = Selenium::WebDriver.for :chrome
  wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  @d.get("https://katsulog.tech/")

  urls = []
  loop do
    wait.until { @d.find_elements(:class, "post").size > 0 }
    @d.find_elements(:class, "post").each do |post|
      urls << post.find_element(:tag_name, "h2").find_element(:tag_name, "a").attribute("href")
    end

    if @d.find_elements(:xpath, '//*[@class="next page-numbers"]').size > 0
      @d.find_element(:xpath, '//*[@class="next page-numbers"]').click
    else
      break
    end
  end

  i = 1
  saiko_str = "最高"
  urls.each do |url|
    @d.get(url)
    title = @d.find_element(:id, "main").find_element(:tag_name, "h2").text
    page_url = @d.current_url
    #CSV.open("result.csv", "a") do |file|
    CSV.open("result_ensyu.csv", "a") do |file|
      file << [i, title, page_url, saiko_str]
    end
    i += 1
  end
end

#tutorial2
#tutorial3
#tutorial4
#tutorial5
#tutorial6
#tutorial8
#tutorial9
#tutorial10
#tutorial11
#tutorial12

tutorial12_2
