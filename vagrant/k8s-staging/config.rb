# config.rb

module Config
    # Environment Configuration
    BASE_IMAGE = "gadgie/ubuntu24.04"
    HOSTNAME_BASE = "k8s-staging"
  
    # Cloud Init Configuration
    CLOUD_INIT = true
    CLOUD_INIT_ISO = "#{Dir.pwd}/seeds/cloud-init.iso"
    BUILD_ISO = true

    # SSH Configuration
    SSH_INSERT_KEY = false
    SSH_KEY_TYPE = "ed25519"
  
    # Cluster Configuration
    NODES = 3
  
    # Network Configuration
    NETWORK = "192.168.6"
    NETMASK = "255.255.255.224"
    GATEWAY = "192.168.6.1"
  
    # VM Configuration
    GUI = false
    LINKED_CLONE = false
    MEMORY = 4096
    CPUS = 2
  
    def self.validate!
      errors = []
  
      errors << "BASE_IMAGE must be a non-empty String" unless BASE_IMAGE.is_a?(String) && !BASE_IMAGE.empty?
      errors << "HOSTNAME_BASE must be a non-empty String" unless HOSTNAME_BASE.is_a?(String) && !HOSTNAME_BASE.empty?
  
      errors << "CLOUD_INIT must be true or false" unless [true, false].include?(CLOUD_INIT)
      errors << "CLOUD_INIT_ISO must be a valid path string ending in .iso" unless CLOUD_INIT_ISO.is_a?(String) && File.extname(CLOUD_INIT_ISO) == ".iso"
      errors << "BUILD_ISO must be true or false" unless [true, false].include?(BUILD_ISO)
  
      if !NODES.is_a?(Integer) || NODES <= 0
        errors << "NODES must be a positive Integer"
      elsif NODES.even?
        errors << "NODES must be an odd number"
      end

      valid_key_types = ["auto", "rsa", "dsa", "ecdsa", "ecdsa521", "ed25519"]
      errors << "SSH_KEY_TYPE must be one of #{valid_key_types.join(', ')}" unless valid_key_types.include?(SSH_KEY_TYPE)
      
      ip_regex = /\A\d{1,3}(\.\d{1,3}){2}\z/
      full_ip_regex = /\A\d{1,3}(\.\d{1,3}){3}\z/
      errors << "NETWORK must be in 'x.x.x' format" unless NETWORK.match?(ip_regex)
      errors << "NETMASK must be a valid IP format" unless NETMASK.match?(full_ip_regex)
      errors << "GATEWAY must be a valid IP format" unless GATEWAY.match?(full_ip_regex)
  
      errors << "GUI must be true or false" unless [true, false].include?(GUI)
      errors << "LINKED_CLONE must be true or false" unless [true, false].include?(LINKED_CLONE)
      errors << "MEMORY must be an Integer >= 512" unless MEMORY.is_a?(Integer) && MEMORY >= 512
      errors << "CPUS must be an Integer >= 1" unless CPUS.is_a?(Integer) && CPUS >= 1
  
      raise RuntimeError, "Configuration validation failed:\n" + errors.map { |e| " - #{e}" }.join("\n") if errors.any?
  
      true
    end
  end
