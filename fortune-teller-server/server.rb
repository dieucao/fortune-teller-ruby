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
    end

    get '/' do
        return '<a href="/random">/random</a><br /><a href="/fortunes">/fortunes</a><br /><a href="/env">/env</a>'
    end

    get '/fortunes' do
        return FORTUNES.to_json
    end

    get '/random' do
        ret = {}
        ret['fortune'] = FORTUNES.sample
        ret['instance_id'] = INSTNACE_ID
        ret['stack'] = STACK
        return ret.to_json
    end

    get '/env' do
        r = ""
        ENV.keys.each do |k|
            r += "#{k} = #{ENV[k]}<br />\n"
        end
        return r
    end

end