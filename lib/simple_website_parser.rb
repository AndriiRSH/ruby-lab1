require 'nokogiri'
require 'open-uri'
require 'yaml'

module MyApplicationAndrews
  class SimpleWebsiteParser
    def initialize(config_path)
      @config = YAML.load_file(config_path)
      @start_url = @config['start_url']
      @product_link_selector = @config['product_link_selector']
      @name_selector = @config['name_selector']
      @price_selector = @config['price_selector']
      @description_selector = @config['description_selector']
      @image_selector = @config['image_selector']
    end

    def start_parse
      puts "Starting web scraping from #{@start_url}..."
      begin
        document = Nokogiri::HTML(URI.open(@start_url))
      rescue OpenURI::HTTPError => e
        puts "Failed to open URL: #{@start_url} - Error: #{e.message}"
        return
      end

      product_links = document.css(@product_link_selector)
      product_links.each do |link|
        product_url = URI.join(@config['base_url'], link['href']).to_s
        parse_product_page(product_url)
      end
    end

    private

    def parse_product_page(url)
      begin
        page = Nokogiri::HTML(URI.open(url))
      rescue OpenURI::HTTPError => e
        puts "Failed to open product page: #{url} - Error: #{e.message}"
        return
      end

      name = page.at_css(@name_selector)&.text&.strip || 'No name available'
      price = page.at_css(@price_selector)&.text&.strip || 'No price available'
      description = page.at_css(@description_selector)&.text&.strip || 'No description available'
      
      # Перевірка на наявність зображення
      image_element = page.at_css(@image_selector)
      image_url = image_element ? URI.join(@config['base_url'], image_element['src']).to_s : 'No image available'

      puts "Name: #{name}"
      puts "Price: #{price}"
      puts "Description: #{description}"
      puts "Image URL: #{image_url}"
      puts "-" * 20
    rescue => e
      puts "Failed to parse product page: #{url} - Error: #{e.message}"
    end
  end
end
