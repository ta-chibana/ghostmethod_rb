require './data_source'

class Product

  def initialize(id)
    @id = id
    @data_source = DataSource.new
  end

  def fetch_food_info
    food_name  = @data_source.fetch_food_name(@id)
    food_price = @data_source.fetch_food_price(@id)
    to_product_info(food_name, food_price)
  end

  def fetch_book_info
    book_name  = @data_source.fetch_book_name(@id)
    book_price = @data_source.fetch_book_price(@id)
    to_product_info(book_name, book_price)
  end

  private

  def to_product_info(name, price)
    if is_present?(name, price)
      "#{@id}: #{name} (￥#{price})"
    else
      'nothing...'
    end
  end

  def is_present?(*attributes)
    attributes.all?
  end
end

