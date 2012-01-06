require 'net/http'
require 'uri'

module Enchant

  class Engine
    attr_reader :server, :code
    attr_accessor :host, :port, :domain

    def initialize(*urls)
      url = urls.pop || ""


      if url != "" 
        tmp = URI.parse(url)
        @host = tmp.host
        @port = tmp.port

        if @host == nil && @port == nil
          @sane = nil
        else 
          @sane = 1
        end
      else
        @sane = 1
      end
    end

    def is_sane?
      @sane
    end

    def list(wordlist) 
      begin
        File.open(wordlist, 'r') { |f|
          @list = f.readlines
        }
      rescue Errno::ENOENT
        puts "It seems the wordlist file is not present (#{wordlist})"
        @list = nil
      end
    end

    def fuzz(*) 
      # in future some perturbation will be done here
      @list
    end

    def get(path)
      http = Net::HTTP.new(host, port)
      begin
        response = http.get(path)
        @code = response.code
      rescue Net::HTTPBadResponse
        puts #{$!}
        @code=-1
      rescue Errno::ETIMEDOUT
        puts #{$!}
        @code=-1
      end
      @code
    end

    def up?(site)
      Net::HTTP.new(site).head('/').kind_of? Net::HTTPOK
    end  

  end
end
