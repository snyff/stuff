
require 'eventmachine'
require 'pp'
require 'net/http'
require 'uri'

class PastebinScanner

  def initialize(queue)
    @reg = [  ]
    @base = "http://pastebin.com/archive"
    @queue = queue
    @done = []
  end

  def fetch
    link = get_links()
    return if link.nil? or link.empty?
    link.each do |l|
      @queue.push(l[0]) unless @done.include?(l)
    end
  end
  
  def pop
    @queue.pop { |msg|
      get_link msg if msg
      EM.add_timer(3){ pop }   
    }
    
  end
  def get_link(l)
    url = "http://pastebin.com/raw.php?i="+l
    puts "Fetching #{url}"
    uri = URI.parse(url)
    begin  
      response = Net::HTTP.get_response(uri)
    rescue Timeout::Error =>e 
      return
    end
    File.open(l, "w").write response.body
    @reg.each do |r|
      puts "#{url} matches #{r.to_s} " if response.body =~ r
    end
    @done << l
  end

  def get_links() 
    puts "Fetching #{@base}"
    uri = URI.parse(@base)
    begin
      response = Net::HTTP.get_response(uri)
    rescue Timeout::Error =>e 
      return
    end
    response.body.scan(/<td class\=\"icon\"><a href\=\"\/(\w+)\">.*<\/a><\/td>/)
    
  end 

end


EM.run do
  q = EM::Queue.new
  p = PastebinScanner.new(q)
  p.fetch
  EM.add_periodic_timer(30) { p.fetch }
  EM.add_timer(3) { p.pop }
end

