require_relative "./lib/app_config_loader"
require_relative "./lib/logger_manager"
require_relative "./lib/item"
require_relative "./lib/cart"
require_relative "./lib/configurator"
require_relative "./lib/database_connector"
require_relative "./lib/engine"
require_relative "./lib/simple_website_parser"

module  MyApplicationAndrews
  class Main
    def self.start
      # Завантаження конфігурації
      config_loader = AppConfigLoader.new("config/default_config.yaml", "config/yaml")
      config_loader.load_libs
      config_data = config_loader.config
      config_loader.pretty_print_config_data

      # Ініціалізація логування
      LoggerManager.initialize_logger(config_data)
      LoggerManager.log_processed_file("example_file")

      # ================== Лабораторна робота 3.2 ====================
      puts "\n\n===================== Lab3.2 ==========================\n\n"
      item = MyApplicationAndrews::Item.new(name: "Item 1", price: 150) do |i|
        i.description = "Here is description 1"
        i.category = "Category 1"
      end
      puts item
      puts item.to_h
      puts item.inspect

      item.update do |i|
        i.name = "New Item"
        i.price = 100
      end
      puts item.info

      fake_item = MyApplicationAndrews::Item.generate_fake
      puts fake_item.info

      # Тестування класу Cart
      # Тестування класу Cart
      cart = MyApplicationAndrews::Cart.new
      cart.generate_test_items(5)
      cart.show_all_items

      # Викликаємо методи з аргументами (ім'я файлу)
      cart.save_to_file('cart_items.txt')
      cart.save_to_json('cart_items.json')
      cart.save_to_csv('cart_items.csv')
      cart.save_to_yml('cart_items.yml')


      puts "Class info: #{Cart.class_info}"
      puts "Total items created: #{cart.item_count}"

      expensive_items = cart.items.select { |item| item.price > 50 }
      puts "Expensive items: #{expensive_items}"


      # ================== Лабораторна робота 3.3 ====================
      puts "\n\n===================== Lab3.3 ==========================\n\n"
      configurator = MyApplicationAndrews::Configurator.new
      configurator.configure(
        run_website_parser: 1,
        run_save_to_csv: 1,
        run_save_to_yaml: 1,
        run_save_to_sqlite: 1
      )

      puts "\n\n===================== Lab3.4 ==========================\n\n"
      config_path = "./config/yaml/web_parser.yaml"
      parser = MyApplicationAndrews::SimpleWebsiteParser.new(config_path)
      parser.start_parse
      puts "Website parsing completed."
      # ================== Лабораторна робота 3.5 ====================
      puts "\n\n===================== Lab3.5 ==========================\n\n"
      config_path = "./config/yaml/database_config.yaml"
      connector = DatabaseConnector.new(config_path)
      connector.connect_to_database

      connector.close_connection
      puts "Database connection closed."

      # ================== Лабораторна робота 3.6 ====================
      puts "\n\n===================== Lab3.6 ==========================\n\n"
      engine = MyApplicationAndrews::Engine.new(config_path)
      engine.run(config_data)  # Запускаємо основний процес на основі конфігурації
    end
  end
end

MyApplicationAndrews::Main.start
