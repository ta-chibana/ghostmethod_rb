require './data_source'

class Product

  def initialize(id)
    @id = id
    @data_source = DataSource.new
  end

  def food_detail
    food_name  = @data_source.fetch_food_name(@id)
    food_price = @data_source.fetch_food_price(@id)
    detail(food_name, food_price)
  end

  def book_detail
    book_name  = @data_source.fetch_book_name(@id)
    book_price = @data_source.fetch_book_price(@id)
    detail(book_name, book_price)
  end

  private

  def detail(name, price)
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
