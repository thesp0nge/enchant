require 'net/http'
require 'httpclient'
require 'uri'

module Enchant
  class Engine
    attr_reader :urls_open
    attr_reader :urls_internal_error
    attr_reader :urls_private

    def initialize(options={})
      @host = options[:host]
      @port = options[:port]
      @wordlist = options[:wordlist]
      @verbose = options[:verbose]
    end

    
    def fuzz(*) 
      # in future some perturbation will be done here
      get_list
    end

    def scan
      http = Net::HTTP.new(host, port)
      list = get_list

      @urls_open={}
      @urls_internal_error={}
      @urls_private={}

      list.each do |path|
        begin
          response = http.get(path)
          c = response.code
          if c == 200
            @urls_open << path
          end
          if c == 401
            @urls_private << path
          end
          if c >= 500
            @urls_internal_error << path
          end
        rescue Net::HTTPBadResponse
          if @verbose
            puts "#{$!}".color(:red)
          end
        rescue Errno::ETIMEDOUT
          if @verbose
            puts "#{$!}".color(:red)
          end
        end

      end
    end

    def up?
      Net::HTTP.new(@host, @port).head('/').kind_of? Net::HTTPOK
    end  


    private
    def get_list
      begin
        File.open(@wordlist, 'r') { |f|
          @list = f.readlines
        }
      rescue Errno::ENOENT
        puts "it seems the wordlist file is not present (#{wordlist})".color(:red)
        @list = nil
      end
    end

  end
end
