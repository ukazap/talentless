# Talentless

Automate clock in/clock out in [Talenta](https://www.talenta.co/en/).

## Setup

Install the following items:

* Google Chrome or Chromium

* Ruby 3.1.1

* Dependencies

  ```
  bundle install --without=development
  ````

## Usage

To try out in your local environment, set the following environment variables and run the script:

```
export TALENTLESS_HEADLESS="true"
export TALENTLESS_EMAIL="<your talenta email>"
export TALENTLESS_PASSWORD="<your talenta password>"
export TALENTLESS_LATITUDE="-7.271487840230101"
export TALENTLESS_LONGITUDE="112.741817856013"
export TALENTLESS_TIME_ZONE="+07:00"
export TALENTLESS_SLACK_WEBHOOK="<your slack webhook url>"

bundle exec ruby talentless.rb
```

## Automation

First, fork this repository.

A [GitHub Action workflow](.github/workflows/clock.yaml) is defined with `workflow_dispatch` trigger.

Add all required [action secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) to your fork.

You can change the trigger to cron, but I find them unreliable.

What I personally do is set up a scenario in [Make.com](https://www.make.com/en) that [makes request](https://docs.github.com/en/actions/managing-workflow-runs/manually-running-a-workflow#running-a-workflow-using-the-rest-api) to GitHub REST API by schedule.
