require 'rubygems'
require 'net/http'
require 'uri'


class Enchant
  attr_reader :host, :port, :server, :code
  
  VERSION = '0.1.0'
  
  def initialize(url)
    tmp = URI.parse(url)
    @host = tmp.host
    @port = tmp.port
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
  end
  
  def ping(*)
    Net::HTTP.start(host, port) { |http| 
      response = http.head("/")
      response.each { |key,val| 
        if "server" == key 
          @server=val
        end 
      }
    }
  end
  
  def to_s() 
    "Enchant v"+VERSION+" - (C) 2010, thesp0nge@gmail.com"
  end
  
  def self.version()
    "Enchant v"+VERSION
  end
end
