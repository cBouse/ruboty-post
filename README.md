# Ruboty::Post

Ruboty handler to post message to other channel by using Incoming Webhook.

## Installation

Before you install ruboty-post, make sure you have done setup the Incoming Webhook on your workspace.

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-post', '=<version>', github: "cBouse/ruboty-post.git"
```

## Usage

```
ruboty post <channel> <username(optional)> <icon(optional)> <message>
ruboty anonymous <channel> <message>
```

## Env

```
WEBHOOK_URI - You must set your WEBHOOK URI
```

## Example

If you receive a channel name like ##hoge, it's must be private channel.

```
> ruboty post #general bar
You posted to #general
> ruboty post #general foo :bar: hoge
You posted to #general
> ruboty anonymous #general hoge
You posted to #general as anonymous
```
