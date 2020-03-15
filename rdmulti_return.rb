# paths:
#   /:
#     file.dir: examples/doc_root
#     mruby.handler-file: /path/to/hello.rb

require 'byebug'
require 'clipboard'

class RdMultiReturn 
  @@redis_uri = URI(ENV["REDIS_URL"])
  @@data = File.read('fixture.json')
  @@fixture = JSON.parse(@@data)
  @@fixture_multi = @@fixture.each_with_index.map{|v, i| [i, v]}.flatten 
  @@times = (ENV['PAGE_SIZE'] || '20').to_i
  @@fixture_keys = (ENV['PAGE_SIZE'] || '20').to_i.times.to_a
  def call(env)
    redis = Redis.new(host: @@redis_uri.hostname, port: @@redis_uri.port)
    redis.auth @@redis_uri.password if @@redis_uri.password 
    now_simple = Time.now

    json = redis.mget(@@fixture_keys).map{|item| JSON.parse(item)}.to_json 
    [200,
     {
      "content-type" => "application/json; charset=utf-8",
    },
    ["#{json}"]
    ]

  end
end

$rdmulti_return = RdMultiReturn.new
