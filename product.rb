require './data_source'

# 1つの製品の情報を取得するクラス.
# DataSourceクラスを利用して値を取得する.
class Product

  def initialize(id)
    @id = id
  end

  def fetch_food_info
    data_source = DataSource.new
    food_name  = data_source.fetch_food_name(@id)
    food_price = data_source.fetch_food_price(@id)
    to_product_info(food_name, food_price)
  end

  def fetch_book_info
    data_source = DataSource.new
    book_name  = data_source.fetch_book_name(@id)
    book_price = data_source.fetch_book_price(@id)
    to_product_info(book_name, book_price)
  end

  private

  def to_product_info(name, price)
    product_info = -> { "#{@id}: #{name} (￥#{price})" }
    is_present?(name, price) ? product_info.call : 'nothing...'
  end

  def is_present?(*attributes)
    attributes.all?
  end
end

