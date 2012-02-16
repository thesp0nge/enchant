require 'net/http'
require 'httpclient'
require 'uri'
require 'progressbar'

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
    def self.help
      puts "usage: enchant -wVvh target"
      puts "       -w file: specifiy the text file to be used as dictionary"
      puts "       -V: be verbose"
      puts "       -v: shows version"
      puts "       -h: this help"
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

      
      pbar = ProgressBar.new("urls", list.size)
      list.each do |path|
        begin
          pbar.inc
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
      pbar.finish
      @urls_open.count
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
