require 'mysql'

def connect_to_mysql(user, password, db_name)
  if !@db
    @db = Mysql.init
    @db.options(Mysql::SET_CHARSET_NAME, 'utf8')
    @db = @db.real_connect('localhost', user, password, db_name)
  end
  return @db
end

def get_mysql
  connect_to_mysql($mysql_user,$mysql_password,$mysql_db_name)
end
