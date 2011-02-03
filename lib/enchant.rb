require 'rubygems'
require 'net/http'
require 'uri'
require 'ping'
require 'Net/ping'
include Net


class Enchant
  attr_reader :server, :code
  attr_accessor :host, :port, :domain
  
  VERSION = '0.4.0'
  
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
  
  def is_alive?
    code.to_i==200
  end
  
  def ping?(host)
    # TCP pinging
    if Ping.pingecho(host)
      return true
    end
    #else
    #  icmp = Net::Ping::ICMP.new(host)
    #  if icmp.ping?
    #    return true
    #  else
    #    return false
    #  end
    #end
    false
  end
  
  def to_s() 
    "Enchant v"+VERSION+" - (C) 2010, thesp0nge@gmail.com"
  end
  
  def self.version()
    @version = File.exist?('VERSION') ? File.read('VERSION') : VERSION
    "Enchant v"+@version
  end
end
