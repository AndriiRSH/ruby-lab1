module MyApplicationName
  module ItemContainer

    module ClassMethods
      def class_info
        "Class: #{self.name}, Version: 1.0"
      end

      def created_objects_count
        @created_objects_count ||= 0
        @created_objects_count += 1
      end
    end

    # Методи екземпляра
    module InstanceMethods
      def add_item(item)
        @items << item
        LoggerManager.log_processed_file("Added item: #{item.name}")
      end

      def remove_item(item)
        @items.delete(item)
        LoggerManager.log_processed_file("Removed item: #{item.name}")
      end

      def delete_items
        @items.clear
        LoggerManager.log_processed_file("Cleared all items")
      end

      def method_missing(method, *args)
        if method == :show_all_items
          @items.each { |item| puts item.info }
        else
          super
        end
      end
    end

    # Callback при включенні модуля
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end
  end
end
