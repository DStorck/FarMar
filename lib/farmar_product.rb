class FarMar::Product

  attr_reader :product_id, :name, :vendor_id
  # self.all: returns a collection of instances, representing all of the objects described in the CSV
  def initialize(product_info)
    @product_id, @name, @vendor_id = product_info
    @product_id = @product_id.to_i
    @vendor_id = @vendor_id.to_i
  end

  def self.all
    CSV.read(PRODUCT_CSV).map do |line|
      self.new(line)
    end
  end

  def self.find(id)
    CSV.foreach(PRODUCT_CSV) do |line|
      return self.new(line) if line[0].to_i == id
    end
  end

  #vendor: returns the FarMar::Vendor instance that is associated with this vendor
  #using the FarMar::Product vendor_id field
  def vendor
    CSV.foreach(VENDORS_CSV) do |line|
      return FarMar::Vendor.new(line) if line[0].to_i == vendor_id
    end
  end

  # sales: returns a collection of FarMar::Sale instances that are associated using
  # the FarMar::Sale product_id field.
  def sales
    sales = CSV.read(SALE_CSV).select do |line|
      line[4].to_i == self.product_id
    end
    sales.collect { |sale| FarMar::Sale.new(sale)}
  end

  #number_of_sales: returns the number of times this product has been sold.
  def number_of_sales
    sales.length
  end

  #self.by_vendor(vendor_id): returns all of the products with the given vendor_id
  def self.by_vendor(vendor_id)
    products = CSV.read(PRODUCT_CSV).select do |line|
      line[2].to_i == vendor_id
    end
    products.collect { |product| FarMar::Product.new(product)}
  end

  # def self.by_vendor(vendor_id)
  #   FarMar::Product.all.select { |product| product.vendor_id == vendor_id}
end



# 1. ID - (Fixnum) uniquely identifies the product
# 2. Name - (String) the name of the product (not guaranteed unique)
# 3. Vendor_id - (Fixnum) a reference to which vendor sells this product

# def sales
#   FarMar::Sale.all.select { |sale| sale.product_id == product_id}
# end

# def vendor
#   FarMar::Vendor.all.select { |vendor| vendor.vendor_id == vendor_id}
# end



# def self.all
#   all_product_info = []
#   CSV.open("./support/products.csv", 'r') do |csv|
#     csv.read.each do |line|
#       all_product_info.push(self.new(product_id: line[0], name: line[1], vendor_id: line[2]))
#     end
#   end
#   return all_product_info
# end

# def self.find(id)
#   all_products = self.all
#   all_products.each do |product|
#     return product if product.product_id == id
#   end
#   nil
# end
