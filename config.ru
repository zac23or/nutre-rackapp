
load "students.rb"
load "pog.rb"
load "bcrpt.rb"
load "rd.rb"
load "rdmulti.rb"
load "rdmulti_return.rb"
load "rdsg.rb"
load "jsn.rb"

class App
  def call(env)
    if env["REQUEST_PATH"] == "/students" 
      return $students_app.call(env)           
    elsif env["REQUEST_PATH"] == "/pg"
      return $pg.call(env)           
    elsif env["REQUEST_PATH"] == "/bcrypt"
      return $bc.call(env)           
    elsif env["REQUEST_PATH"] == "/rd"
      return $rd.call(env)
    elsif env["REQUEST_PATH"] == "/rdsg"
      return $rdsg.call(env)
    elsif env["REQUEST_PATH"] == "/rdmulti"
      return $rdmulti.call(env)           
    elsif env["REQUEST_PATH"] == "/rdmultir"
      return $rdmulti_return.call(env)           
    elsif env["REQUEST_PATH"] == "/json"
      return $jsn.call(env)           
    else
    text = %{ 
      <html>
      <body>
        <a href='/pg'>Teste abertura/fechamento conexão pg</a> <br>
        <h1>PG puro</h1>
        <a href='/students?pageSize=40'>Teste pega 40 estudantes no pg</a> <br>
        <a href='/students?pageSize=20'>Teste pega 20 estudantes no pg</a> <br>
        <a href='/students?pageSize=10'>Teste pega 10 estudantes no pg</a> <br>
        <a href='/students?pageSize=1'>Teste pega 1 estudantes no pg</a> <br>
        <h1>PG com redis</h1>
        <a href='/students?pageSize=40&redis=true'>Teste pega 40 estudantes no pg</a> <br>
        <a href='/students?pageSize=20&redis=true'>Teste pega 20 estudantes no pg</a> <br>
        <a href='/students?pageSize=10&redis=true'>Teste pega 10 estudantes no pg</a> <br>
        <a href='/students?pageSize=1&redis=true'>Teste pega 1 estudantes no pg</a> <br>
        <h1>Redis</h1>
        <a href='/rd'>Teste abertura/fechamento conexão redis</a><br>
        <a href='/rdsg'>Teste setar/pegar valor em chave redis</a><br>
        <h1>Redis GET/MULTI GET</h1>
        <a href='/rdmulti'>Teste setar/pegar valor em chave redis(normal 20 vezes vs  multi)</a><br>
        <h1>Redis MULTI GET RETURN</h1>
        <a href='/rdmultir'>retorna 20 students via multiget</a><br>
        <h1>BCrypt</h1>
        <a href='/bcrypt'>Teste login com bcrypt</a><br>
        <h1>JSON</h1>
        <a href='/json'>Test 40 dict para json</a><br>
      </body>
      </html>
    }
    end
    [200,
     {
      "content-type" => "text/html; charset=utf-8",
    },
    ["#{text}\n"]
    ]

  end
end

run App.new
