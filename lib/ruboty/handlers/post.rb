require 'net/http'
require 'uri'
require 'json'

module Ruboty
  module Handlers
    class Post < Base
      env :WEBHOOK_URI, 'WEBHOOK URI of your workstation', optional: false

      on /post (?<channel>\S*) ((?<username>\S*) )?((?<icon>:.*:) )?(?<text>.*)/, name: 'post', description: 'Send message to other channel'
      on /anonymous (?<channel>\S*) (?<text>.*)/, name: 'anonymous', description: 'Send message to other channel as anonymous'


      def anonymous(message)
        username = 'Anonymous'
        icon = ':ghost:'
        params = {text: message[:text], channel: message[:channel], username: username, icon_emoji: icon}
        if http_request?(params)
          message.reply("You posted to \##{message[:channel]} as anonymous")
        else
          message.reply('Error')
        end
      end

      def post(message)
        if message[:channel].start_with?('#') then
          message.reply('Are you sure about the channel name?')
          return
        end

        unless message[:username] then
          username = message.original[:mention_to][0]['name']
        else
          username = message[:username]
        end

        unless message[:icon] then
          icon = message.original[:mention_to][0]['image_original']
        else
          icon = message[:icon]
        end

        params = {text: message[:text], channel: message[:channel], username: username, icon_emoji: icon}
        if http_request?(params)
          message.reply("You sent to \##{message[:channel]}")
        else
          message.reply("Error")
        end
      end

      def http_request?(params)
        uri = URI.parse(ENV['WEBHOOK_URI'])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = TRUE

        http.start do
          request = Net::HTTP::Post.new(uri.path)
          request.set_form_data(payload: params.to_json)
          @response = http.request(request)
        end

        if @response.message.eql?('OK')
          return true
        else
          return false
        end
      end
    end
  end
end
