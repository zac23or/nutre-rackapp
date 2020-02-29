# paths:
#   /:
#     file.dir: examples/doc_root
#     mruby.handler-file: /path/to/hello.rb
require 'bcrypt'

class Bc 
  def call(env)
    now = Time.now
    hashed_password = BCrypt::Password.create('plain text password')
    text = (Time.now - now).to_s
    [200,
     {
      "content-type" => "text/html; charset=utf-8",
    },
    ["#{text}\n"]
    ]

  end
end

$bc = Bc.new
