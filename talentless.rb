require "ferrum"
require_relative "setting.rb"

def base_url(path = nil)
  "https://hr.talenta.co#{path}"
end

def login_failed?(page)
  !page.at_css(".alert.alert-danger").nil?
end

def still_loading?(page)
  page.frames.any? { |f| f.state != :stopped_loading }
end

def wait_until
  loop do
    break if yield
    sleep 1
  end
end

def current_time
  Time.now.getlocal(Setting::TIME_ZONE)
end

browser = Ferrum::Browser.new(headless: Setting::HEADLESS)
context = browser.contexts.create
page = context.create_page

puts "Spoofing geolocation #{Setting::LATITUDE}, #{Setting::LONGITUDE}"
page.command("Browser.grantPermissions", permissions: ["geolocation"], origin: base_url, browserContextId: context.id)
page.command("Page.setGeolocationOverride", latitude: Setting::LATITUDE, longitude: Setting::LONGITUDE, accuracy: 100)

page.go_to(base_url)

print "Logging in as `#{Setting::EMAIL}`... "

email_input = page.at_css("input#user_email")
email_input.focus.type(Setting::EMAIL)

password_input = page.at_css("input#user_password")
password_input.focus.type(Setting::PASSWORD)

previous_url = page.current_url

sign_in_button = page.at_css("#new-signin-button")
sign_in_button.click

wait_until do
  login_failed?(page) or
    (page.current_url != previous_url and not still_loading?(page))
end

if login_failed?(page)
  raise "Login failed."
end

puts "we're in."

page.go_to(base_url("/live-attendance"))

wait_until { page.at_css("#tl-live-attendance-index").inner_text.match?(/Loading/) }
wait_until { !page.at_css("#tl-live-attendance-index").inner_text.match?(/Loading/) }

log = 
  if page.at_css(".tl-blankslate").nil?
    page.css("#tl-live-attendance-index ul li").map { |li| li.inner_text.split("\n\n").take(2) }
  else
    []
  end

if not log.empty?
  puts "\nLog:"
  log.each do |i|
    puts i.join(": ")
  end
  puts ""
end

last_time, last_action = log.last

case last_action
when nil
  if (8..10).include?(current_time.hour)
    puts "Clocking in..."
    clock_in_button = page.css(".btn-primary").find { |b| b.inner_text == "Clock In" }
    clock_in_button.click
    puts "Done."
  else
    raise "Cannot clock in now #{current_time}"
  end
when "Clock In"
  earliest_time_to_clock_out =
    Time.parse("#{last_time} #{Setting::TIME_ZONE}") + 60 * 60 * 9
  
  if current_time >= earliest_time_to_clock_out
    puts "Clocking out..."
    clock_out_button = page.css(".btn-primary").find { |b| b.inner_text == "Clock Out" }
    clock_out_button.click
    puts "Done."
  else
    raise "Cannot clock out now #{current_time}"
  end
when "Clock Out"
  puts "All good today."
else
  raise "I don't know what's going on."
end

# todo check calendar before clocking in/out
# todo request attendance if telat ?
# todo send screenshot to slack
# page.screenshot(path: "ss.png")

# todo send error to slack

browser.quit
