#!/usr/bin/ruby
require "selenium-webdriver"

# 事前準備
# gem install selenium-webdriver
# gem install ocra

# 必要なら以下も
# gem install ffi

# EXE化
# ocra --add-all-core sample_selenium.rb

# 環境構築不要で配布！ruby+seleniumのコードをexe化【chromedriver】
# http://katsulog.tech/ruby_selenium_chrome_exe/

Selenium::WebDriver::Chrome.driver_path = "./chromedriver.exe"
driver = Selenium::WebDriver.for :chrome
