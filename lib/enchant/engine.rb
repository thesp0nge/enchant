require 'net/http'
require 'net/https'
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

      if @port == "443"
        http.use_ssl = true
        http.ssl_timeout = 2
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      list = get_list
      if list.empty?
        return 0
      end

      refused=0
      @urls_open=[]
      @urls_internal_error=[]
      @urls_private=[]

      
      pbar = ProgressBar.new("urls", list.size)
      list.each do |path|
        pbar.inc
        if ! path.start_with? '#'
          begin
            response = http.get('/'+path.chop)
            c = response.code.to_i
            refused = 0
            if c == 200 or c == 302
              @urls_open << path
            end
            if c == 401
              @urls_private << path
            end
            if c >= 500
              @urls_internal_error << path
            end
          rescue Errno::ECONNREFUSED
            refused += 1
            if refused > 5
              pbar.finish
              puts "received 5 connection refused. #{@host} went down".color(:red)
              return @urls_open.count 
            else
              puts "[WARNING] connection refused".color(:yellow)
              sleep 2 * refused
            end
            
          rescue Net::HTTPBadResponse
            refused = 0
            if @verbose
              puts "#{$!}".color(:red)
            end
          rescue Errno::ETIMEDOUT
            refused = 0
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
      begin
        Net::HTTP.new(@host, @port).get('/')
        return true
      rescue Net::HTTPBadResponse
        return true
      rescue Errno::ECONNREFUSED
        return false
      rescue Errno::ETIMEDOUT
        return false
      end
    end  


    private
    def get_list

      if @wordlist.nil?
        if File.exists?('../../db/directory-list-2.3-small.txt')
          @wordlist='../../db/directory-list-2.3-small.txt'
        end
        if File.exists?('./db/directory-list-2.3-small.txt')
          @wordlist='./db/directory-list-2.3-small.txt'
        else
          @list = {}
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
