# paths:
#   /:
#     file.dir: examples/doc_root
#     mruby.handler-file: /path/to/hello.rb

class RdMulti 
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

    @@times.times do |i|
      redis.set(i,@@fixture[0])
    end
    @@times.times do |i|
      redis.get(i)
    end

    text_simple = (Time.now - now_simple).to_s
    multi_now = Time.now
    
    redis.mset(*@@fixture_multi)
    
    redis.mget(*@@fixture_keys)

    text_multi = (Time.now - multi_now).to_s
    [200,
     {
      "content-type" => "text/html; charset=utf-8",
    },
    ["#{text_simple}<br>#{text_multi}"]
    ]

  end
end

$rdmulti = RdMulti.new
