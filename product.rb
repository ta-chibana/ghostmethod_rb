require './data_source.rb'

class Product
  def initialize(id)
    @id = id
    @data_source = DataSource.new
  end

  def food
    name = @data_source.get_food_name(@id)
    price = @data_source.get_food_price(@id)
    to_s(name, price)
  end

  def book
    name = @data_source.get_book_name(@id)
    price = @data_source.get_book_price(@id)
    to_s(name, price)
  end

  private
  def to_s(name, price)
    if present?(name, price)
      "#{@id}: #{name} (￥#{price})"
    else
      'nothing...'
    end
  end

  def present?(*result)
    result.all? { |data| !(data.nil?) }
  end
end
