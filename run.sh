cd /workspace/spec/dummy
touch tmp/pids/server.pid
rm tmp/pids/server.pid
bundle exec rails s -p 3000 -b '0.0.0.0'
