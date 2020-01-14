#!/bin/bash

FILE=/usr/src/app/tmp/pids/server.pid
if test -f "$FILE"; then
  rm $FILE
fi

CMD='gem install rails -v ${RAILS_VERSION}'
grep 'rails' 'Gemfile' >/dev/null 2>&1
if [ $? -gt 0 ]; then
  eval $CMD
  rails new . --database=postgresql
  echo $APP_NAME
  sed -i '/adapter: postgresql/a \ \ host: db\n\ \ username: postgres' config/database.yml
  sed -i "s/app_development/${APP_NAME}_development/" config/database.yml
fi

bundle install --without=production --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3
sleep 2m
if ! psql -h db -U postgres -lqt | cut -d \| -f 1 | grep -qw ${APP_NAME}_development; then
  bundle exec rake db:create db:migrate db:seed
else
  bundle exec rake db:migrate
fi

bin/rails s -p 3000 -b 0.0.0.0
