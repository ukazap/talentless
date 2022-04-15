# Talentless

Automate punch in/punch out in Talenta.

## Setup

Install the following items:

* Google Chrome or Chromium

* Ruby 3.1.1

* Dependencies

  ```
  bundle install --without=development
  ````

## Usage

Set the following environment variables and run the script:

```
export TALENTLESS_EMAIL="gabut@example.com"
export TALENTLESS_PASSWORD="12345simsalabim"
export TALENTLESS_LATITUDE="-7.271487840230101"
export TALENTLESS_LONGITUDE="112.741817856013"
export TALENTLESS_TIME_ZONE="+07:00"
export TALENTLESS_HEADLESS="true"
export TALENTLESS_SLACK_WEBHOOK="<your slack webhook url>"

bundle exec ruby talentless.rb
```
