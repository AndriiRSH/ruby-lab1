module MyApplicationAndrews
  class Cart
    attr_accessor :items

    # Конструктор для ініціалізації масиву items
    def initialize
      @items = []
    end

    # Збереження інформації в текстовому файлі
    def save_to_file(file_name)
      File.open(file_name, 'w') do |file|
        @items.each { |item| file.puts item.to_s }
      end
      LoggerManager.log_processed_file(file_name)
    end

    # Збереження інформації в JSON
    def save_to_json(file_name)
      require 'json'
      File.open(file_name, 'w') do |file|
        file.write(@items.to_json)
      end
      LoggerManager.log_processed_file(file_name)
    end

    # Збереження інформації в CSV
    def save_to_csv(file_name)
      require 'csv'
      CSV.open(file_name, 'w') do |csv|
        @items.each { |item| csv << item.to_h.values }
      end
      LoggerManager.log_processed_file(file_name)
    end

    # Збереження інформації в YAML
    def save_to_yml(file_name)
      require 'yaml'
      File.open(file_name, 'w') do |file|
        @items.each { |item| file.puts item.to_h.to_yaml }
      end
      LoggerManager.log_processed_file(file_name)
    end

    # Метод для генерування тестових даних
    def generate_test_items(count)
      count.times do
        item = Item.generate_fake
        @items << item
      end
    end

    # Додайте метод для виведення всіх товарів у кошику
    def show_all_items
      @items.each { |item| puts item.to_s }
    end

    # Статичний метод для інформації про клас
    def self.class_info
      "This is the Cart class, which holds items in a shopping cart."
    end

    # Метод для отримання кількості елементів у кошику
    def item_count
      @items.size
    end
  end
end
