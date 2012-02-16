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
      http = Net::HTTP.new(@host, @port)
      list = get_list
      if list.empty?
        return 0
      end

      @urls_open={}
      @urls_internal_error={}
      @urls_private={}

      
      pbar = ProgressBar.new("urls", list.size)
      list.each do |path|
        pbar.inc
        puts "#{path}".color(:yellow)
        if ! list.start_with? '#'
          begin
            response = http.get('/'+path)
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
      pbar.finish
      @urls_open.count
    end

    def up?
      Net::HTTP.new(@host, @port).get('/').kind_of? Net::HTTPOK
    end  


    private
    def get_list

      if @wordlist.nil?
        if File.exists?('../../db/directory-list-2.3-small.txt')
          @wordlist='../../db/directory-list-2.3-small.txt'
        end
        if File.exists?('./db/directory-list-2.3-small.txt')
          @wordlist='./db/directory-list-2.3-small.txt'
        end

      end

      begin
        File.open(@wordlist, 'r') { |f|
          @list = f.readlines
        }
      rescue Errno::ENOENT
        puts "it seems the wordlist file is not present (#{@wordlist})".color(:red)
        @list = {}
      end
    end

  end
end
