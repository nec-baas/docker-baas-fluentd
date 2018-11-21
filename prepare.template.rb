# -*- coding: utf-8 -*-
require 'mongo'

puts("prepare.rb start.")

client_host = ['$CLIENT_HOST']
user = '$MONGO_USERNAME'
password = '$MONGO_PASSWORD'

client_options = {
  database: 'admin',
  user: user,
  password: password
}

# baas_log データベースを作成
begin
  client = Mongo::Client.new(client_host, client_options)
  db = client.use('baas_log')

  # ユーザを追加する
  result = db.database.users.info(user)

  if result.empty?
    puts('create user')

    db.database.users.create(
      user,
      password: password,
      roles: [ Mongo::Auth::Roles::READ_WRITE ])
  end

  client.close
rescue StandardError => err
  puts(err)
end

puts("prepare.rb end.")
