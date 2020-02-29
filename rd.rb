# paths:
#   /:
#     file.dir: examples/doc_root
#     mruby.handler-file: /path/to/hello.rb


class Rd 
  @@redis_uri = URI(ENV["REDIS_URL"])
  def call(env)
    now = Time.now
    redis = Redis.new(host: @@redis_uri.hostname, port: @@redis_uri.port)
    redis.auth @@redis_uri.password 
    redis.close
    text = (Time.now - now).to_s
    [200,
     {
      "content-type" => "text/html; charset=utf-8",
    },
    ["#{text}\n"]
    ]

  end
end

$rd = Rd.new
