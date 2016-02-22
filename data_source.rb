require 'pg'

class DataSource
  def get_food_name(id)
    result = get_data('foods', 'name', id)
    return_data(result, 'name')
  end

  def get_food_price(id)
    result = get_data('foods', 'price', id)
    return_data(result, 'price')
  end

  def get_book_name(id)
    result = get_data('books', 'name', id)
    return_data(result, 'name')
  end

  def get_book_price(id)
    result = get_data('books', 'price', id)
    return_data(result, 'price')
  end

  #  def get_onigiri_name(id)
  #    result = get_data('onigiris', 'name', id)
  #    return_data(result, 'name')
  #  end
  #
  #  def get_onigiri_price(id)
  #    result = get_data('onigiris', 'price', id)
  #    return_data(result, 'price')
  #  end

  private
  def get_data(table_name, column, id)
    connection = PG::connect(host: 'localhost', 
                             user: 'postgres', 
                             password: 'postgres', 
                             dbname: 'metapro_demo', 
                             port: '5432')
    result = connection.exec("select #{column} from #{table_name} where id = #{id}")
  ensure
    connection.finish
    result
  end

  def return_data(data, column)
    data.first[column] if present?(data)
  end

  def present?(data)
    data.respond_to?(:first) && !(data.first.nil?)
  end
end
