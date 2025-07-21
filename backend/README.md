Liste os containers (mesmo os parados):

docker ps -a
Pare os containers ativos que estão usando essa rede:

docker stop simulate-pit-stop-api_frontend_1 simulate-pit-stop-api_db_1 simulate-pit-stop-api_backend_1
Remova esses containers:

docker rm simulate-pit-stop-api_frontend_1 simulate-pit-stop-api_db_1 simulate-pit-stop-api_backend_1
Agora remova a rede:

docker network rm simulate-pit-stop-api_default
Por fim, faça o build e up novamente:

docker-compose up --build

Tudo Junto:
docker-compose down && docker network rm simulate-pit-stop-api_default && docker-compose up --build


Reconstrua do zero (limpando cache):

Para garantir que o Docker copie o novo entrypoint.sh, execute:

docker-compose down --volumes --remove-orphans
docker-compose build --no-cache
docker-compose up