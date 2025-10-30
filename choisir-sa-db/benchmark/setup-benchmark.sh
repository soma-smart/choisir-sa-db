docker run -d --name postgres \
  -e POSTGRES_PASSWORD=secretpw \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql \
  postgres:18.0


docker run -d --name clickhouse \
  --ulimit nofile=262144:262144 \
  -e CLICKHOUSE_PASSWORD=secretpw \
  -p 8123:8123 -p 9000:9000 \
  -v ch_data:/var/lib/clickhouse \
  -v ch_logs:/var/log/clickhouse-server \
  clickhouse/clickhouse-server:25.9

wget https://github.com/soma-smart/Fakelake/releases/latest/download/fakelake-x86_64-unknown-linux-musl.tar.gz

tar -xzf fakelake-x86_64-unknown-linux-musl.tar.gz

chmod +x fakelake

