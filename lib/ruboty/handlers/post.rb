require 'net/http'
require 'uri'
require 'json'

module Ruboty
  module Handlers
    class Post < Base
      env :WEBHOOK_URI, 'WEBHOOK URI of your workstation', optional: false

      on /post\s+(?<channel>\S*)\s+((?<username>\S*)\s+)?((?<icon>:[^:]*:){1}\s+)(?<text>.+)/m, name: 'post', description: 'Send message to other channel'
      on /anonymous\s+(?<channel>\S*)\s+(?<text>.+)/m, name: 'anonymous', description: 'Send message to other channel as anonymous'


      def anonymous(message)
        username = 'Anonymous'
        icon = ':ghost:'
        text = replace_broadcast(message[:text])
        params = {text: text, channel: message[:channel], username: username, icon_emoji: icon}
        if http_request?(params)
          message.reply("You posted to \##{message[:channel]} as anonymous")
        else
          message.reply('Error')
        end
      end

      def post(message)
        unless message[:username]
          username = message.original[:mention_to][0]['name']
        else
          username = message[:username]
        end

        unless message[:icon]
          icon = message.original[:mention_to][0]['image_original']
        else
          icon = message[:icon]
        end

        text = replace_broadcast(message[:text])
        params = {text: text, channel: message[:channel], username: username, icon_emoji: icon}
        if http_request?(params)
          message.reply("You sent to \##{message[:channel]}")
        else
          message.reply("Sorry! I could not post your message.")
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

      def replace_broadcast(text)
        message = text.gsub(/\B@here/, '<!here>')
        message = message.gsub(/\B@channel/, '<!channel>')
        return message
      end
    end
  end
end
