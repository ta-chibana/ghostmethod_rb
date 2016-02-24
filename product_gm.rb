require './data_source.rb'

class Product < BasicObject
  def initialize(id)
    @id = id
    @data_source = ::DataSource.new
  end

  def method_missing(method_name)
    method_name.match(/^(\w*)_detail$/)
    table_name = $1
    super unless @data_source.respond_to?("fetch_#{table_name}_name")
    product_name = @data_source.send("fetch_#{table_name}_name", @id)
    product_price = @data_source.send("fetch_#{table_name}_price", @id)
    detail(product_name, product_price)
  end

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
