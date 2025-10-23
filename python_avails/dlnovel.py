from selenium import webdriver
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.firefox.options import Options
from bs4 import BeautifulSoup
import time

geckodriver_path = "./.venv/bin/geckodriver"
firefox_options = Options()
firefox_options.add_argument("--headless") # Uncomment for headless browsing
service = Service(executable_path=geckodriver_path)
driver = webdriver.Firefox(service=service, options=firefox_options)

html_url = "https://czbooks.net/n/uif2km/s6onoh1f?chapterNumber=702"
fp = open("novel.txt", "w", encoding="utf8")

for chap_num in range(702, 876, 1):
    #print(html_url)
    driver.get(html_url)
    soup = BeautifulSoup(driver.page_source, "lxml")
    tag_div = soup.find("div", class_ = "content")
    print(driver.title)
    #print(tag_div)
    fp.write(tag_div.text + '\n\n')
    page_next = soup.find("a", class_ = "next-chapter")
    html_url = "https:" + page_next.get("href")
    page_next.click
    time.sleep(2)
    driver.refresh()

driver.quit()
fp.close

#soup.select('a[href]')：選取所有帶有 href 屬性的 <a> 標籤。 soup.find_all('a')：找到所有 <a> 標籤，並以列表形式回傳。
