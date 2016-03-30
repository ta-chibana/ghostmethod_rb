require 'pg'

class DataSource
  def fetch_food_name(id)
    pg_result = fetch_data!('foods', 'name', id)
    return_data(pg_result, 'name')
  end

  def fetch_food_price(id)
    pg_result = fetch_data!('foods', 'price', id)
    return_data(pg_result, 'price')
  end

  def fetch_book_name(id)
    pg_result = fetch_data!('books', 'name', id)
    return_data(pg_result, 'name')
  end

  def fetch_book_price(id)
    pg_result = fetch_data!('books', 'price', id)
    return_data(pg_result, 'price')
  end

  #  def fetch_onigiri_name(id)
  #    pg_result = fetch_data!('onigiris', 'name', id)
  #    return_data(pg_result, 'name')
  #  end
  #
  #  def fetch_onigiri_price(id)
  #    pg_result = fetch_data!('onigiris', 'price', id)
  #    return_data(pg_result, 'price')
  #  end

  private

  def fetch_data!(table_name, column_name, id)
    connect_db do |connection|
      safe_table_name  = connection.quote_ident(table_name)
      safe_column_name = connection.quote_ident(column_name)

      connection.exec <<-SQL
        SELECT #{safe_column_name} FROM #{safe_table_name} WHERE id = #{id}
      SQL
    end
  end

  def connect_db!
    db_conf = YAML.load_file('./database.yml')['db']['development']
    connection = PG.connect(host: db_conf['host'], 
                            user: db_conf['user'], 
                            password: db_conf['password'], 
                            dbname: db_conf['dbname'], 
                            port: db_conf['port'])

    pg_result = yield(connection)
  ensure
    connection.finish
    pg_result
  end

  def return_data(data, column_name)
    data.first[column_name] if present?(data)
  end

  def present?(data)
    data.respond_to?(:first) && !(data.first.nil?)
  end
end

