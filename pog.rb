# paths:
#   /:
#     file.dir: examples/doc_root
#     mruby.handler-file: /path/to/hello.rb

require 'pg'


class Pg 
  @@database_uri = URI(ENV["DATABASE_URL"])
  def call(env)
    now = Time.now
    conn = PG.connect :dbname => @@database_uri.path[1..], :user => @@database_uri.user, 
        :password => @@database_uri.password, port: @@database_uri.port, host: @@database_uri.hostname 
    text = (Time.now - now).to_s
    [200,
     {
      "content-type" => "text/html; charset=utf-8",
    },
    ["#{text}\n"]
    ]

  end
end

$pg = Pg.new
