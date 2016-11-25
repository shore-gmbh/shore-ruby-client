module Shore
  class VersionsManager
    include Singleton

    attr_reader :versions_map, :default_namespace

    def initialize
      @versions_map = {}.freeze
      @default_namespace = nil
    end

    def load_version(version_name)
      require_version_files(version_name)

      @versions_map = versions_map.merge(
        version_name => VersionNamespace.new(version_name: version_name)
      ).freeze
    end

    def set_default_api_version(version_name)
      raise 'Not allowed to override default version' unless default_namespace.nil?

      @default_namespace = versions_map[version_name]
      default_namespace.become_root
    end

    def default_version
      default_namespace.version_name
    end

    private

    def require_version_files(version_name)
      Dir[version_files(version_name)].each { |file| require(file) }
    end

    def version_files(version_name)
      "#{File.dirname(__FILE__)}/#{version_name}/**/*.rb"
    end
  end

  class VersionNamespace
    attr_reader :version_name

    def initialize(params)
      @version_name = params.fetch(:version_name)
    end

    def constants
      constant_names.map do |constant_name|
        namespaced_constant(constant_name)
      end
    end

    def constant_names
      root_constants.map { |constant| find_nested_constants(constant) }.flatten
    end

    def become_root
      constant_names.map do |constant_name|
        head, *tail = constant_name.to_s.split('::')

        Shore.const_set(
          head,
          nested_constant(tail, namespaced_constant(constant_name))
        )
      end
    end

    private

    def nested_constant(path, base)
      return base if path.size == 0
      return module_for(path.first, add: base) if path.size == 1

      nested_constant(path[1..-1], base)
    end

    def module_for(path, add: nil)
      mod = Module.new
      mod.const_set(path, add) unless add.nil?
      mod
    end

    def find_nested_constants(constant)
      return constant if is_a_client?(constant)

      namespaced_constant(constant).constants.map do |child|
        find_nested_constants("#{constant}::#{child}")
      end
    end

    def root_constants
      root_constant.constants
    end

    def root_constant
      Object.const_get(root_namespace)
    end
    
    def root_namespace
      "Shore::#{version_name.to_s.upcase}"
    end

    def namespaced_constant(const_path)
      Object.const_get("#{root_constant}::#{const_path}")
    end

    def is_a_client?(constant)
      namespaced_constant(constant).respond_to?(:site)
    end
  end
end
