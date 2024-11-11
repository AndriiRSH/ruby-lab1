module MyApplicationAndrews
  class LoggerManager
    class << self
      attr_reader :logger

      def initialize_logger(config_data)
        # Визначення директорії для логів (з заданням значення за замовчуванням)
        log_dir = config_data.dig("logging", "directory") || "logs"
        Dir.mkdir(log_dir) unless Dir.exist?(log_dir)

        # Визначення імені файлу для логів (якщо його нема, встановлюємо "application_log")
        log_file = config_data.dig("logging", "files", "application_log") || "application_log.log"
        
        # Визначення рівня логування (якщо нема, ставимо DEBUG)
        log_level = config_data.dig("logging", "level") || "DEBUG"
        
        # Перевірка коректності рівня логування
        valid_log_levels = ["DEBUG", "INFO", "WARN", "ERROR", "FATAL", "UNKNOWN"]
        unless valid_log_levels.include?(log_level)
          raise ArgumentError, "Invalid log level: #{log_level}. Valid levels are #{valid_log_levels.join(', ')}."
        end
        
        @logger = Logger.new(File.join(log_dir, log_file))
        @logger.level = Logger.const_get(log_level)
      end

      def log_info(message)
        @logger.info(message)
      end

      def log_processed_file(file_name)
        @logger.info("Processed file: #{file_name}")
      end

      def log_error(error_message)
        @logger.error("Error: #{error_message}")
      end
    end
  end
end