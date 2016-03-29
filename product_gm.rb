require './data_source'

class Product < BasicObject

  def initialize(id)
    @id = id
    @data_source = ::DataSource.new
  end

  private

  def method_missing(method_name)
    product_type = to_product_type(method_name)

    super unless @data_source.respond_to?("fetch_#{product_type}_name")

    product_name  = @data_source.send("fetch_#{product_type}_name", @id)
    product_price = @data_source.send("fetch_#{product_type}_price", @id)
    to_product_info(product_name, product_price)
  end

  def to_product_type(method_name)
    method_name.match(/\Afetch_(\w*)_info\z/)
    $1
  end

  def to_product_info(name, price)
    if present?(name, price)
      "#{@id}: #{name} (￥#{price})"
    else
      'nothing...'
    end
  end

  def present?(*attributes)
    attributes.all?
  end
end

