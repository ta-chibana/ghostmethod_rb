# frozen_string_literal: true
require 'pg'

class DataSource

  FOOD_TABLE_NAME = 'foods'
  BOOK_TABLE_NAME = 'books'
  PRODUCT_NAME_COLUMN = 'name'
  PRODUCT_PRICE_COLUMN = 'price'

  DB_CONF_FILE_PATH = './database.yml'

  def fetch_food_name(id)
    pg_result = fetch_data!(FOOD_TABLE_NAME, PRODUCT_NAME_COLUMN, id)
    return_data(pg_result, PRODUCT_NAME_COLUMN)
  end

  def fetch_food_price(id)
    pg_result = fetch_data!(FOOD_TABLE_NAME, PRODUCT_PRICE_COLUMN, id)
    return_data(pg_result, PRODUCT_PRICE_COLUMN)
  end

  def fetch_book_name(id)
    pg_result = fetch_data!(BOOK_TABLE_NAME, PRODUCT_NAME_COLUMN, id)
    return_data(pg_result, PRODUCT_NAME_COLUMN)
  end

  def fetch_book_price(id)
    pg_result = fetch_data!(BOOK_TABLE_NAME, PRODUCT_PRICE_COLUMN, id)
    return_data(pg_result, PRODUCT_PRICE_COLUMN)
  end

  private

  def fetch_data!(table_name, column_name, id)
    connect_db! do |connection|
      safe_table_name  = connection.quote_ident(table_name)
      safe_column_name = connection.quote_ident(column_name)

      connection.exec <<-SQL
        SELECT #{safe_column_name} FROM #{safe_table_name} WHERE id = #{id}
      SQL
    end
  end

  def connect_db!
    db_conf = YAML.load_file(DB_CONF_FILE_PATH)['db']['development']
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

