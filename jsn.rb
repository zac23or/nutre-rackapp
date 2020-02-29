# paths:
#   /:
#     file.dir: examples/doc_root
#     mruby.handler-file: /path/to/hello.rb

DB_USER = 'u54nveehr0far3'
DB_PWD = 'p46b19c6c8bf51d9f7b4485b2eaee26b27b353631eb11d18c9660c135c77c3449'
DB_HOST = '52.21.142.217' 
DB_NAME = 'dcb5nkl8rr7qvt'
DB_PORT = 5432
DICTS = [{"id":5385,"name":"Neymar Cunha","grade":"4ª","classroom":"","balance":"247.84",
"available_limit_for_today":"3.0","birthday":"2002-12-31","does_not_use_password_on_terminal":false,"gender":"male",
"last_active_card":{"id":50074,"number":"500740","track2":";00668533=076161270570492005385?\n"},
"login":nil,"negative_limit":"0.0","pdv":false,"post_paid":false,"registration_number":"00006001","restricted_stores":[],"restrictions":[],"terminal_password":"1234",
"imported":true,"most_consumed_products_ids":[],"activated_at":"2015-01-25T00:00:00.000-02:00"},{"id":5386,"name":"Selton Silva","grade":"6ª","classroom":"",
"balance":"-88.2","available_limit_for_today":"-1.0","birthday":"2005-08-15","does_not_use_password_on_terminal":false,"gender":"male",
"last_active_card":{"id":5462,"number":"T15S5386","track2":";00747550=076160170529108005386?\n"},"login":nil,
"negative_limit":"0.0","pdv":false,"post_paid":false,"registration_number":"00006002","restricted_stores":[],"restrictions":[],"terminal_password":"1234","imported":true,"most_consumed_products_ids":[],"activated_at":"2015-10-15T00:00:00.000-03:00"}]
39.times do
  DICTS.push(DICTS.first)
end
class Jsn 
  def call(env)
    now = Time.now
    text = JSON.generate(DICTS)
    text = (Time.now - now).to_s
    [200,
     {
      "content-type" => "text/html; charset=utf-8",
    },
    ["#{text}\n"]
    ]

  end
end

  
$jsn = Jsn.new
