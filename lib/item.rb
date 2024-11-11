module MyApplicationAndrews
  class Item
    attr_accessor :name, :price, :description, :category, :image_path

    def initialize(name:, price:, description: "", category: "", image_path: "default_image.jpg")
      @name = name
      @price = price
      @description = description
      @category = category
      @image_path = image_path
    end

    # Для виведення інформації про товар
    def to_h
      {
        name: @name,
        price: @price,
        description: @description,
        category: @category,
        image_path: @image_path
      }
    end

    def to_s
      "Item: #{@name}, #{@price}, #{@description}, #{@category}, #{@image_path}"
    end

    def update
      yield self if block_given?
    end

    # Генерація тестових даних
    def self.generate_fake
      Item.new(
        name: "Fake Item",
        price: rand(1..100).to_f,
        description: "Fake description",
        category: "Fake category",
        image_path: "default_image.jpg"
      )
    end

    def info
      "#{@name}: #{@price} - #{@description}, #{@category}, #{@image_path}"
    end
  end
end
