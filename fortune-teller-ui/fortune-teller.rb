require 'sinatra'
require 'erb'
require "net/http"

class FortuneTeller < Sinatra::Base

    configure do
        FORTUNE_SERVER_URL = "http://localhost:9293"
        INSTNACE_ID = ENV['CF_INSTANCE_INDEX']

        TEMPLATE = File.open('templates/index.html.erb', 'rb', &:read)
    end

    get '/' do
        ERB.new(TEMPLATE).result(binding)
    end

    get ':file' do
        File.open("public/#{params[file]}", 'rb', &:read)
    end

    get '/js/:file' do
        File.open("public/js/#{params[file]}", 'rb', &:read)
    end

    get '/random' do
        url = URI.parse("#{FORTUNE_SERVER_URL}/random")
        Net::HTTP.get_response(url).body
    end

    get '/env' do
        r = ""
        ENV.keys.each do |k|
            r += "#{k} = #{ENV[k]}<br />\n"
        end
        return r
    end

end