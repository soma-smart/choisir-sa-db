docker network create ch_pg_net

docker run -d --name postgres \
  --network ch_pg_net \
  -e POSTGRES_PASSWORD=secretpw \
  -p 5432:5432 \
  -v /data/pgdata:/var/lib/postgresql \
  -v ./output:/output \
  postgres:18.0


docker run -d --name clickhouse \
  --network ch_pg_net \
  --ulimit nofile=262144:262144 \
  -e CLICKHOUSE_PASSWORD=secretpw \
  -p 8123:8123 -p 9000:9000 \
  -v /data/ch_data:/var/lib/clickhouse \
  -v /data/ch_logs:/var/log/clickhouse-server \
  clickhouse/clickhouse-server:25.9

wget https://github.com/soma-smart/Fakelake/releases/latest/download/fakelake-x86_64-unknown-linux-musl.tar.gz

tar -xzf fakelake-x86_64-unknown-linux-musl.tar.gz

chmod +x fakelake

fakelake generate arcades.yml games.yml players.yml plays_fact.yml