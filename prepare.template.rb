# -*- coding: utf-8 -*-
require 'mongo'

puts("prepare.rb start.")
# client_host の設定は bootstrap.sh にて行われる

client_options = {
  database: 'admin',
  user: '%MONGO_USERNAME%',
  password: '%MONGO_PASSWORD%'
}

# baas_log データベースを作成
begin
  client = Mongo::Client.new(client_host, client_options)
  db = client.use('baas_log')

  # ユーザを追加する
  result = db.database.users.info('%MONGO_USERNAME%')

  if result.empty?
    puts('create user')

    db.database.users.create(
      '%MONGO_USERNAME%',
      password: '%MONGO_PASSWORD%',
      roles: [ Mongo::Auth::Roles::READ_WRITE ])
  end

  client.close
rescue StandardError => err
  puts(err)
end

puts("prepare.rb end.")
