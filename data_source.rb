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
    connection = PG::connect(host: 'localhost', 
                             user: 'postgres', 
                             password: 'postgres', 
                             dbname: 'metapro_demo', 
                             port: '5432')
    pg_result = connection.exec <<-SQL
      select #{column_name} from #{table_name} where id = #{id}
    SQL
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
