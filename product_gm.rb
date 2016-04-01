require './data_source'

# 1つの製品の情報を取得するクラス.
# DataSourceクラスを利用して値を取得する.
class Product < BasicObject

  def initialize(id)
    @id = id
  end

  private

  # Productクラスが持たないメソッド呼び出しをフックする.
  # メソッド名が /\Afetch_(\w*)_info\z/ にマッチすると,
  # (\w*)にマッチした部分に応じて
  # DataSourceクラスに定義された各メソッドを呼び出し,製品の情報を返す.
  # DataSourceクラスに定義されていないメソッドが呼ばれる場合,
  # NoMethodErrorを発生させる.
  #
  # Example
  #  class DataSource
  #    def fetch_food_name; end
  #    def fetch_food_price; end
  #  end
  #  
  #  pro = Product.new(id)
  #  pro.fetch_food_name
  #   => DataSource#fetch_food_name, DataSource#fetch_food_price を呼び出す.
  #  pro.fetch_drink_name
  #   => raise NoMethodError
  def method_missing(method_name)
    data_source = ::DataSource.new
    product_type = to_product_type(method_name)

    super unless data_source.respond_to?("fetch_#{product_type}_name")

    product_name  = data_source.send("fetch_#{product_type}_name", @id)
    product_price = data_source.send("fetch_#{product_type}_price", @id)
    to_product_info(product_name, product_price)
  end

  def to_product_type(method_name)
    method_name.match(/\Afetch_(\w*)_info\z/)
    $1
  end

  def to_product_info(name, price)
    product_info = -> { "#{@id}: #{name} (￥#{price})" }
    is_present?(name, price) ? product_info.call : 'nothing...'
  end

  def is_present?(*attributes)
    attributes.all?
  end
end

