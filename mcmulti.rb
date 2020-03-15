# paths:
#   /:
#     file.dir: examples/doc_root
#     mruby.handler-file: /path/to/hello.rb
require 'dalli'

class Mcmulti 
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
      json = @cache.get_multi(*@@fixture_keys).values.to_json
    rescue
      @cache = nil
    end
    [200,
     {
      "content-type" => "application/json; charset=utf-8",
    },
    ["#{json}"]
    ]

  end
end

$mcmulti = Mcmulti.new
