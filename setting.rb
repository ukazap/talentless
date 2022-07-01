module Setting
  EMAIL         = ENV.fetch("TALENTLESS_EMAIL")
  PASSWORD      = ENV.fetch("TALENTLESS_PASSWORD")
  LATITUDE      = ENV.fetch("TALENTLESS_LATITUDE").to_f
  LONGITUDE     = ENV.fetch("TALENTLESS_LONGITUDE").to_f
  TIME_ZONE     = ENV.fetch("TALENTLESS_TIME_ZONE", "+07:00")
  HEADLESS      = ENV.fetch("TALENTLESS_HEADLESS", "true") == "true"
  SLACK_WEBHOOK = ENV["TALENTLESS_SLACK_WEBHOOK"].to_s
  HUSH_HUSH     = ENV["TALENTLESS_HUSH_HUSH"] == "true" # silent logs
end
