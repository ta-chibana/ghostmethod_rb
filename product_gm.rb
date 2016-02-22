require './data_source.rb'

class Product < BasicObject
  def initialize(id)
    @id = id
    @data_source = ::DataSource.new
  end

  def method_missing(source)
    super unless @data_source.respond_to?("get_#{source}_name")
    name = @data_source.send("get_#{source}_name", @id)
    price = @data_source.send("get_#{source}_price", @id)
    to_s(name, price)
  end

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
