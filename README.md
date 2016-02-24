People
======

[![Code Climate](http://img.shields.io/codeclimate/github/netguru/people.svg)](https://codeclimate.com/github/netguru/people)
[![Dependencies](http://img.shields.io/gemnasium/netguru/people.svg)](https://gemnasium.com/netguru/people)
[![Circle CI](https://circleci.com/gh/netguru/people.svg?style=svg)](https://circleci.com/gh/netguru/people) [![codebeat badge](https://codebeat.co/badges/b780ba79-c497-4216-9d02-93a0b3701de5)](https://codebeat.co/projects/github-com-blaszczakphoto-people)

## About the app

The main purpose of the app is to manage people within the projects.

The main table shows the current teams in each project, but you can also add people who will start working on the project in the future, and see the people who are going to join or leave the project team by clicking “highlight ending” and “highlight next”. The app also gathers the information about a team member, like role, telephone number, github nick, or the city in which we work.

## Technology stack

* Rails 4.2.5
* Ruby 2.1.5
* ReactJS 0.14.2
* PostgreSQL

## System Setup
You need ImageMagick installed on your system, on OS X this is a simple as:
```shell
  brew update && brew install imagemagick
```
On other systems check out the official [ImageMagick](http://www.imagemagick.org/script/binary-releases.php) documentation.

Since the app uses capybara-webkit for running feature specs, you need to have `qt` installed on your machine (preferably v5 or higher) before running the setup script.

## Project setup

 * run
  ```bash
    bin/setup
  ```
 * the setup script will create your own copy of database.yml and sec_config.yml for your local configuration
 * the app uses Google Auth; in order to configure it, check **Dev auth setup** and **Local settings** sections below
 * once you get your authentication credentials, go to `config/sec_config.yml` and update your `google_client_id`, `google_secret`, `google_domain`, `github_client_id`, `github_secret` accordingly
 * in `config/sec_config.yml` set `emails/internal` to the domain which you want to allow for new users
 * create a Slack team account and configure its integration (see **Slack integration** below)

### Development

* run `rails s`
* run webpack in watch mode:
  ```
  npm start
  ```

### Local settings

You should put your local settings in `config/sec_config.yml` file which is not checked in version control.

Note that emails->internal is required if you want to sign up in the app and should contain the domain used to login users eg. `example.com`, NOT the full email like `test@example.com`.

### Additional Info

 * after logging in, go to your Profile's settings and update your role to 'senior' or 'pm'
 * by default only 'pm' and 'senior' roles have admin privileges - creating new projects, managing privileges, memberships etc.
 * optionally update your emails and company_name
 * after deploy run `rake team:set_fields` - it sets avatars and team colors.

### Integrations

Trello integration is optional, but **without Slack integration, the app will throw errors** every time you do something that sends Slack notifications (most actions in the app).

#### Trello integration

1. Get your developer key from https://trello.com/1/appKey/generate
2. Use the developer key to obtain a token with read/write privileges: https://trello.com/1/authorize?key=DEV_KEY&name=APP_NAME&expiration=never&response_type=token&scope=read,write
3. Make sure that everything works fine https://api.trello.com/1/board/BOARD_ID?key=APP_KEY&token=MEMBER_TOKEN
4. Add credentials to `sec_config.yml`

```yaml
  trello:
    enabled:              true
    developer_public_key: DEV_KEY
    member_token:         MEMBER_TOKEN
    schedule_board_id:    BOARD_ID
```

#### Slack integration

1. Get slack webhook url (more info
[https://team-name.slack.com/services/new/incoming-webhook](https://team-name.slack.com/services/new/incoming-webhook)). You need slack admin support for it.
2. Add credentials to `sec_config.yml`
```yaml
  slack:
    webhook_url:          webhook_url
    username:             PeopleApp
```

## Dev auth setup

### Google Auth

  * goto [https://console.cloud.google.com/](https://console.cloud.google.com/)
  * create new project
  * click `Use Google APIs` > `Credentials` > `OAuth consent screen` (second tab)
  * fill in "Email address" and "Product name" and save
  * go to `Credentials` (first tab)
  * Create client ID: `New Credentials` > `OAuth client ID`
  * choose `Web application` option
  * set `Authorized JavaScript origins` to:
  ```
    http://localhost:3000
  ```
  * set `Authorized redirect URI` to
  ```
    http://localhost:3000/users/auth/google_oauth2/callback
  ```

### Github Auth
  * go to: [https://github.com/settings/applications/new](https://github.com/settings/applications/new)
  * create github application (callback address is `http://localhost:3000/users/auth/github/callback`)

### Feature flags

The app uses Feature flags through Flip gem. The feature flag panel (requires admin privileges) is available at `/features`.

### Gemsurance - keep gems up to date

Profile app uses `gemsurance` as development dependency. It should be used to check which gems are up to date.
To use it just write in console:

```bash
bundle exec gemsurance
```

It will generate HTML file with list of gems. Gems in bold are the one specified in `Gemfile`.

### Read More

[Introducing: People. A simple open source app for managing devs within projects](https://netguru.co/blog/posts/introducing-people-a-simple-open-source-app-for-managing-devs-within-projects).

### Contributing

First, thank you for contributing!

Here a few guidelines to follow:

1. Write tests
2. Make sure the entire test suite passes
3. Make sure rubocop passes, our [config](https://github.com/netguru/hound/blob/master/config/rubocop.yml)
3. Open a pull request on GitHub
4. [Squash your commits](http://blog.steveklabnik.com/posts/2012-11-08-how-to-squash-commits-in-a-github-pull-request) after receiving feedback

Copyright (c) 2014-2016 [Netguru](https://netguru.co). See LICENSE for further details.
