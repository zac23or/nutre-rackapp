mkdir ab

echo "pg"
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/pg > ab/pg_open_close.txt
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/students?pageSize=40 > ab/pg_40_alunos.txt
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/students?pageSize=20 > ab/pg_20_alunos.txt
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/students?pageSize=10 > ab/pg_10_alunos.txt
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/students?pageSize=1 > ab/pg_1_aluno.txt

echo "pg com redis"
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/students?pageSize=40\&redis=1 > ab/pg_com_redis_40_alunos.txt
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/students?pageSize=20\&redis=1 > ab/pg_com_redis_20_alunos.txt
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/students?pageSize=10\&redis=1 > ab/pg_com_redis_10_alunos.txt
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/students?pageSize=1\&redis=1 > ab/pg_com_redis_1_aluno.txt

echo "redis cria conexao"
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/rd > ab/redis_cria_conexao.txt
echo "redis set get"
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/rdsg > ab/redis_set_get.txt

echo "bcrypt"
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/bcrypt > ab/bcrypt.txt

echo "json"
ab -n 10000 -c 100 https://nutre-rackapp.herokuapp.com/json > ab/json.txt


