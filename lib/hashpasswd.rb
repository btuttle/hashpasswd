module Hashpasswd
  HASH_SECTIONS = 4
  ITERATIONS_INDEX = 1
  SALT_INDEX = 2
  HASH_INDEX = 3
  DEFAULT_DELIMETER = ':'

  require 'securerandom'
  require 'base64'

  # Creates a hash from a plain text password
  # @param password [String] A plain text password
  # @param [Hash{Symbol => String, Number}] options
  # @option options [Int] :pbkdf2_iterations (2000) The PBKDF2 iteration count
  # @option options [Int] :salt_byte_size (24) The byte size for the salt (The salt should probably be at least 64 bits: http://en.wikipedia.org/wiki/PBKDF2)
  # @option options [Int] :hash_byte_size (24) The byte size for the hash
  # @option options [String] :delimiter (':') The delimeter for the hash string, changing the delimiter is not recommended as you will have to remember it and supply it as an option to validatepasswd()
  # @option options [String] :digest ('SHA1') The digest, can be any digest supported by OpenSSL on your sytem (eg 'SHA224', 'SHA256', 'SHA384' or 'SHA512')
  # @return [String] the hash as "<digest>:<pbkdf2_iterations>:<salt>:<hash>"
  #
  def self.createhash(password, options={})
    #Needs to be increased as cpu speeds increase: http://en.wikipedia.org/wiki/PBKDF2
    @pbkdf2_iterations = options[:pbkdf2_iterations] || 2000
    #The salt should probably be at least 64 bits: http://en.wikipedia.org/wiki/PBKDF2
    @salt_byte_size = options[:salt_byte_size] ||24
    @hash_byte_size = options[:hash_byte_size]|| 24
    @delimeter = options[:delimter] || ':'
    @digest = options[:digest] || 'SHA1'

    salt = OpenSSL::Random.random_bytes(@salt_byte_size)
    pbkdf2 = OpenSSL::PKCS5::pbkdf2_hmac(
      password,
      salt,
      @pbkdf2_iterations,
      @hash_byte_size,
      @digest
   )
    return [@digest, @pbkdf2_iterations, salt, Base64.encode64(pbkdf2)].join(@delimeter)
  end

  # Validates a password against a hash
  # @param password [String] A plain text password
  # @param hash [String] "<digest>:<pbkdf2_iterations>:<salt>:<hash>" 
  # @param [Hash{Symbol => String}] options 
  # @option options [String] :delimiter (':') The delimeter for the hash string, only necessary if you did not use the default delimiter (':') when creating the hash. 
  # @return [Boolean] True if the password matches the hash; False if not.
  #
  def self.validatepasswd(password, hash, options={})
    @delimeter = options[:delimter] || ':'

    params = hash.split(@delimeter)
    return false if params.length != HASH_SECTIONS

    pbkdf2 = Base64.decode64(params[HASH_INDEX])
    testhash = OpenSSL::PKCS5::pbkdf2_hmac(
      password,
      params[SALT_INDEX],
      params[ITERATIONS_INDEX].to_i,
      pbkdf2.length,
      params[0] 
   )

    return pbkdf2 == testhash
  end

  # Get the values of all constants
  # @param none
  # @return [Hash] of all constants
  def self.getconstants()
    return {:HASH_SECTIONS => HASH_SECTIONS, :ITERATIONS_INDEX => ITERATIONS_INDEX, :SALT_INDEX => SALT_INDEX, :HASH_INDEX => HASH_INDEX, :DEFAULT_DELIMETER => DEFAULT_DELIMETER}
  end
end
