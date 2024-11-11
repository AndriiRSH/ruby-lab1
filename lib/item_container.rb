module MyApplicationAndrews
  module ItemContainer
    module InstanceMethods
      def add_item(item)
        @items << item
        LoggerManager.log_processed_file("Item added: #{item.name}")
      end

      def remove_item(item)
        @items.delete(item)
        LoggerManager.log_processed_file("Item removed: #{item.name}")
      end

      def delete_items
        @items.clear
        LoggerManager.log_processed_file("All items deleted")
      end

      def show_all_items
        @items.each { |item| puts item }
      end

      def each
        @items.each { |item| yield item }
      end
    end

    module ClassMethods
      def class_info
        "Class: #{self}, Version: 1.0"
      end

      def created_objects
        @created_objects ||= 0
        @created_objects += 1
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end
  end
end
