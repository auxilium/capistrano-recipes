Dir[File.join(File.dirname(__FILE__), 'recipes/*.rb')].sort.each { |lib| require lib }
