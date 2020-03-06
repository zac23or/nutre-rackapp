require 'pg'
require 'redis'

class Student
  @@init = false
  def initialize(map)
    keys = map.keys

    keys.each do |key|
      self.send("#{key}=", map[key])
    end
  end

  def to_json g
    result = {}
    instance_variables.each do |variable|
      result[variable.to_s[1..-1]] = instance_variable_get(variable) 
    end
    g.generate(result)
  end

  def self.init(keys)
    return if @@init
    keys.each do |key|
      Student.attr_accessor key.to_sym
    end
    @@init = true
  end
end


SELECT_STUDENTS =  %{ SELECT 
id, name, grade, classroom, balance, birthday, 
does_not_use_password_on_terminal, gender, login, negative_limit, pdv, post_paid, registration_number, restricted_stores, terminal_password,
imported, most_consumed_products_ids,activated_at  FROM students order by id limit $1 offset 1 * $2}

class StudentApp
  @@database_uri = URI(ENV["DATABASE_URL"])
  @@redis_uri = URI(ENV["REDIS_URL"])
  def call(env)
    page = 1

    if env['QUERY_STRING']
      qs = env['QUERY_STRING'].split('&').map{|item| item.split('=')}.to_h
      page = (qs['page'] || '0').to_i - 1
      page = [0, page].max
      page_size = (qs['pageSize'] || '0').to_i
      redis = (qs['redis'] || nil)
    end
    now = Time.now
    inited = false
    students = nil
    if redis
      cache_ident="#{students}-#{page}-#{page_size}"
      @redis ||= Redis.new(host: @@redis_uri.hostname, port: @@redis_uri.port)
      @redis.auth @@redis_uri.password 
      students = @redis.get(cache_ident)
    end
    if (!students)  
      @conn ||= PG.connect :dbname => @@database_uri.path[1..], :user => @@database_uri.user, 
        :password => @@database_uri.password, port: @@database_uri.port, host: @@database_uri.hostname 
      @conn.type_map_for_results ||= PG::BasicTypeMapForResults.new(@conn)
      
      begin
        dataset = @conn.exec(SELECT_STUDENTS, [page_size, page]) 
      rescue
        #limpa uma conexão com problemas
        @conn = nil
      end
      students = []
    
      dataset.each do |result|
        Student.init(result.keys) if !inited
        inited = true 
        students.push Student.new(result)
      end
      students = students.to_json
      @redis.set(cache_ident, students) if redis
    end 
    text = (Time.now - now).to_s
    [200,
     {
      "content-type" => "application/json",
    },
    ["#{students}\n"]
    ]

  end
end

$students_app = StudentApp.new
