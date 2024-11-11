require 'sqlite3'
require 'yaml'
require 'logger'

module MyApplicationAndrews
  class DatabaseConnector
    attr_accessor :db

    def initialize(config_file)
      @config = YAML.load_file(config_file)
      @db = nil
      LoggerManager.log_processed_file("Database connector initialized with config: #{@config}")
    end

    def connect_to_database
      case @config['database_type']
      when 'sqlite'
        connect_to_sqlite
      when 'mongodb'
        connect_to_mongodb
      else
        LoggerManager.log_error("Unsupported database type: #{@config['database_type']}")
        raise "Unsupported database type: #{@config['database_type']}"
      end
    end

    def close_connection
      if @db
        if @db.is_a?(SQLite3::Database)
          @db.close
          LoggerManager.log_processed_file("SQLite connection closed.")
        elsif @db.is_a?(Mongo::Client)
          @db.close
          LoggerManager.log_processed_file("MongoDB connection closed.")
        end
      else
        LoggerManager.log_error("No active database connection to close.")
      end
    end

    private

    def connect_to_sqlite
      db_path = @config['sqlite_database']['db_file']
      if !File.exist?(db_path)
        LoggerManager.log_error("Database file does not exist: #{db_path}")
        raise "Database file does not exist: #{db_path}"
      end
    
      begin
        @db = SQLite3::Database.new(db_path)
        LoggerManager.log_processed_file("Connected to SQLite database at #{db_path}")
      rescue => e
        LoggerManager.log_error("Error connecting to SQLite database: #{e.message}")
        raise "Error connecting to SQLite database: #{e.message}"
      end
    end
    

    def connect_to_mongodb
      uri = @config['mongodb_uri']
      database_name = @config['mongodb_db_name']
      begin
        @db = Mongo::Client.new(uri, database: database_name)
        LoggerManager.log_processed_file("Connected to MongoDB at #{uri}, Database: #{database_name}")
      rescue => e
        LoggerManager.log_error("Error connecting to MongoDB: #{e.message}")
        raise "Error connecting to MongoDB: #{e.message}"
      end
    end
  end
end
