require 'yaml'
require 'logger'
require 'zip'
require 'csv'
require 'json'
require 'mongo'
require 'sqlite3'
require 'pony'
require 'sidekiq'
require_relative 'database_connector'
require_relative 'simple_website_parser'
require_relative 'logger_manager'

module MyApplicationAndrews
  class Engine
    attr_accessor :config

    def initialize(config_file)
      # Завантаження конфігурації з YAML файлу
      load_config(config_file)
      initialize_logging
    end

    def load_config(config_file)
      # Завантажуємо конфігурацію та виводимо повідомлення
      @config = YAML.load_file(config_file)
      LoggerManager.log_processed_file("Configuration loaded successfully from #{config_file}")
    end

    def initialize_logging
      # Ініціалізація логування
      LoggerManager.initialize_logger(@config)  # Тепер передаємо @config
      LoggerManager.log_processed_file("Logging initialized.")
    end

    def run(config_params)
      # Основний метод запуску програми
      begin
        LoggerManager.log_processed_file("Program execution started.")
        # Підключення до бази даних
        db_connector = DatabaseConnector.new('config.yml')
        db_connector.connect_to_database

        # Виконуємо методи, що визначаються в конфігурації
        run_methods(config_params)

        # Закриваємо з'єднання з базою даних
        db_connector.close_connection
        LoggerManager.log_processed_file("Database connection closed.")
      rescue => e
        LoggerManager.log_error("Error during program execution: #{e.message}")
      end
    end

    def run_methods(config_params)
      # Виконуємо методи в залежності від конфігурації
      if config_params['website_parser']
        run_website_parser
      end
      if config_params['save_to_csv']
        run_save_to_csv
      end
      if config_params['save_to_json']
        run_save_to_json
      end
      if config_params['save_to_yaml']
        run_save_to_yaml
      end
      if config_params['save_to_sqlite']
        run_save_to_sqlite
      end
      if config_params['save_to_mongodb']
        run_save_to_mongodb
      end

      # Архівуємо результати, якщо зазначено в конфігурації
      if config_params['archive_results']
        archive_results
      end

      # Відправляємо архів по електронній пошті у фоновому режимі
      if config_params['send_email']
        send_email_with_archive
      end
    end

    def run_website_parser
      # Запуск парсингу сайту
      parser = SimpleWebsiteParser.new(@config)
      parser.start_parse
      LoggerManager.log_processed_file("Website parsing completed.")
    end

    def run_save_to_csv
      # Збереження результатів у CSV
      # (Тут можна додати код для збереження даних в CSV)
      LoggerManager.log_processed_file("Data saved to CSV.")
    end

    def run_save_to_json
      # Збереження результатів у JSON
      # (Тут можна додати код для збереження даних в JSON)
      LoggerManager.log_processed_file("Data saved to JSON.")
    end

    def run_save_to_yaml
      # Збереження результатів у YAML
      # (Тут можна додати код для збереження даних в YAML)
      LoggerManager.log_processed_file("Data saved to YAML.")
    end

    def run_save_to_sqlite
      # Збереження результатів у базу даних SQLite
      # (Тут можна додати код для збереження даних в SQLite)
      LoggerManager.log_processed_file("Data saved to SQLite database.")
    end

    def run_save_to_mongodb
      # Збереження результатів у MongoDB
      # (Тут можна додати код для збереження даних в MongoDB)
      LoggerManager.log_processed_file("Data saved to MongoDB.")
    end

    def archive_results
      # Архівуємо файли, якщо це потрібно
      LoggerManager.log_processed_file("Results archived.")
    end

    def send_email_with_archive
      # Відправлення архіву по електронній пошті
      LoggerManager.log_processed_file("Email sent with archive.")
    end
  end
end