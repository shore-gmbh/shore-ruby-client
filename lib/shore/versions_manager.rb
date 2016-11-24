module Shore
  module VersionsManager
    def self.load_version(version_name)
      Dir[version_files(version_name)].each { |file| require(file) }
    end

    def self.set_default_api_version(version_name)
      set_default_api_for_version_constant(version_name.to_s.upcase)
    end

    def self.version_files(version_name)
      "#{File.dirname(__FILE__)}/#{version_name}/**/*.rb"
    end

    def self.set_default_api_for_version_constant(prefix)
      Object.const_get("Shore::#{prefix}").constants.each do |klass|
        assign_default_client(klass, prefix)
      end
    end

    def self.assign_default_client(class_name, prefix)
      const = Object.const_get("Shore::#{prefix}::#{class_name}")

      if is_a_client?(const)
        Shore.const_set(class_name, const)
      else
        set_default_api_for_version_constant("#{prefix}::#{class_name}")
      end
    end

    def self.is_a_client?(const)
      const.respond_to?(:table_name)
    end
  end
end
