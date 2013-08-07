require 'test/unit'
require './lib/hashpasswd'

class HashpasswdTest < Test::Unit::TestCase

  def test_getconstants
    constants = Hashpasswd.getconstants
    assert_equal 4,
      constants[:HASH_SECTIONS]
    assert_equal 1,
      constants[:ITERATIONS_INDEX]
    assert_equal 2,
      constants[:SALT_INDEX]
    assert_equal 3,
      constants[:HASH_INDEX]
    assert_equal ':',
      constants[:DEFAULT_DELIMETER]
  end

  def test_create_and_validate_hash
    correct_password = 'testpassword'
    wrong_password = 'nottestpassword'
    hash = Hashpasswd.createhash(correct_password)
    assert(Hashpasswd.validatepasswd(correct_password, hash) == true, "correct password")
    assert(Hashpasswd.validatepasswd(wrong_password, hash) == false, "wrong password")
  end

  def test_hash_and_salt_difference
    password = 'somepassword'
    hash = Hashpasswd.createhash(password)
    h1 = hash.split(Hashpasswd.getconstants[:DEFAULT_DELIMETER])
    h2 = Hashpasswd.createhash(password).split(Hashpasswd.getconstants[:DEFAULT_DELIMETER])
    assert(h1[Hashpasswd.getconstants[:HASH_INDEX]] != h2[Hashpasswd.getconstants[:HASH_INDEX]], "different hashes")
    assert(h1[Hashpasswd.getconstants[:SALT_INDEX]] != h2[Hashpasswd.getconstants[:SALT_INDEX]], "different salt")
  end

  def test_multiple_passwords
    password=[]
    password[0] = "42+' x53q~16%vQ"
    password[1] = 'v,@8DDD>mwy%Io0'
    password[2] = 'f=j2p~/U5~bLmgg'
    password[3] = 'Y~k.[*6K{ }^~1V'
    password[4] = 'iLf<!,:P!tF&lg^/w)=4'
    password[5] = 'I2O/#+;|@0<$L."c^%k!;Uz}4'
    password[6] = ",}9#ps&+/'@^=.=3'Nr*X+B2>G+=uh"
    password[7] = 'GPXE)uQxdEx39>sOAfLfxGPkE,KHCT11C}q'
    password[8] = 'p3"3f(V5k7-0%{&}7)[U{/p&7g$}Tv*9+"+^[G1F'
    password[9] = 'bS2FCtXKRxxFTn0m7hyn2TS6MfPxkzkeC42I=9uaIc4vR6PP5r'
    wrong_password = 'P@ssw0rd!'

    hash = []
    for i in 0..(password.length - 1) do
      hash[i] = Hashpasswd.createhash(password[i])
    end

    for i in 0..(hash.length - 1) do
      assert(Hashpasswd.validatepasswd(password[i], hash[i]) == true, "correct password")
      assert(Hashpasswd.validatepasswd(wrong_password, hash[i]) == false, "wrong password")
    end

  end

  def test_hash_difference
    password=[]
    password[0] = "42+' x53q~16%vQ"
    password[1] = 'v,@8DDD>mwy%Io0'
    password[2] = 'f=j2p~/U5~bLmgg'
    password[3] = 'Y~k.[*6K{ }^~1V'
    password[4] = 'iLf<!,:P!tF&lg^/w)=4'
    password[5] = 'I2O/#+;|@0<$L."c^%k!;Uz}4'
    password[6] = ",}9#ps&+/'@^=.=3'Nr*X+B2>G+=uh"
    password[7] = 'GPXE)uQxdEx39>sOAfLfxGPkE,KHCT11C}q'
    password[8] = 'p3"3f(V5k7-0%{&}7)[U{/p&7g$}Tv*9+"+^[G1F'
    password[9] = 'bS2FCtXKRxxFTn0m7hyn2TS6MfPxkzkeC42I=9uaIc4vR6PP5r'

    hash = []
    for i in 0..(password.length - 1) do
      hash[i] = Hashpasswd.createhash(password[i])
    end

    hash2 = []
    for i in 0..(password.length - 1) do
      hash2[i] = Hashpasswd.createhash(password[i])
    end
    
    for i in 0..(hash.length - 1) do
      assert(Hashpasswd.validatepasswd(password[i], hash[i]) == true, "password for hash[#{i}] validates") 
      assert(Hashpasswd.validatepasswd(password[i], hash2[i]) == true, "password for hash2[#{i}] validates")
      assert(hash[i] != hash2[i], "hash[#{i}] != hash2[#{i}]")
    end
  end

end
