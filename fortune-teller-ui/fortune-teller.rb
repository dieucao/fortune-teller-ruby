require 'sinatra'
require 'erb'
require "net/http"
require 'json'

class FortuneTeller < Sinatra::Base

    configure do
        if ENV.has_key? "VCAP_SERVICES" and JSON.parse(ENV["VCAP_SERVICES"]).has_key? "user-provided"
            FORTUNE_SERVER_URL = JSON.parse(ENV["VCAP_SERVICES"])["user-provided"].first["credentials"]["url"]
        else
            FORTUNE_SERVER_URL = "http://localhost:9293"
        end

        
        INSTNACE_ID = ENV['CF_INSTANCE_INDEX'] || "No Instance ID"

        if RUBY_PLATFORM == "x86_64-darwin17"
            STACK = "OS X"
        elsif RUBY_PLATFORM == "x86_64-linux"
            lsb_release = File.open("/etc/lsb-release", 'rb', &:read).split("\n")
            lsb_release.each do |v|
                if v.include? "DISTRIB_DESCRIPTION"
                    STACK = v.split("=").last.gsub("\"", "")
                end
            end

            if STACK.empty?
                STACK = "Unknown Linux Distro"
            end
        else
            STACK = "Unknown Operating System"
        end

        TEMPLATE = File.open('templates/index.html.erb', 'rb', &:read)
    end

    get '/' do
        @stack = STACK
        @instance_id = INSTNACE_ID
        @server_url = FORTUNE_SERVER_URL
        @time = Time.now.utc
        ERB.new(TEMPLATE).result(binding)
    end

    get ':file' do
        File.open("public/#{params[file]}", 'rb', &:read)
    end

    get '/js/:file' do
        File.open("public/js/#{params[file]}", 'rb', &:read)
    end

    get '/random' do
        begin
            url = URI.parse("#{FORTUNE_SERVER_URL}/random")
            return Net::HTTP.get_response(url).body
        rescue
            return "The future is cloudy... (Could not connect to Fortune service)"
        end
    end

    get '/env' do
        r = ""
        ENV.keys.each do |k|
            r += "#{k} = #{ENV[k]}<br />\n"
        end
        return r
    end

end