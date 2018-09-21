require 'sinatra'
require 'json'

class FortuneServer < Sinatra::Base

    configure do
        # Preload list of fortunes
        FORTUNES = []
        File.open("./fortunes.txt", "r") do |f|
            f.each_line do |f|
              FORTUNES << f.strip
            end
        end
    end

    get '/' do
        return '<a href="/random">/random</a><br /><a href="/fortunes">/fortunes</a><br /><a href="/env">/env</a>'
    end

    get '/fortunes' do
        return FORTUNES.to_json
    end

    get '/random' do
        return FORTUNES.sample
    end

    get '/env' do
        r = ""
        ENV.keys.each do |k|
            r += "#{k} = #{ENV[k]}<br />\n"
        end
        return r
    end

end