# paths:
#   /:
#     file.dir: examples/doc_root
#     mruby.handler-file: /path/to/hello.rb

require 'dalli'

class Mc 
  @@data = File.read('fixture.json')
  @@fixture = JSON.parse(@@data)
  @@fixture_multi = @@fixture.each_with_index.map{|v, i| [i, v.to_json]}.flatten
  @@times = (ENV['PAGE_SIZE'] || '20').to_i
  @@fixture_keys = (ENV['PAGE_SIZE'] || '20').to_i.times.to_a
  def call(env)
    unless @cache
      @cache = Dalli::Client.new(
        ENV["MEMCACHEDCLOUD_SERVERS"].split(','), 
        :username => ENV["MEMCACHEDCLOUD_USERNAME"], 
        :password => ENV["MEMCACHEDCLOUD_PASSWORD"])

    end
    begin
      now = Time.now
      @@fixture.each_with_index{|v, i|
        @cache.set(i, v)
      }
      text = (Time.now - now).to_s
    rescue Exception => e
      @cache = nil
      text = e.message
    end
    [200,
     {
      "content-type" => "text/html; charset=utf-8",
    },
    ["#{text}"]
    ]
  end
end

$mc = Mc.new
