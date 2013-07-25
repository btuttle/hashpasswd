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

  def test_createhash
    correct_password = 'testpassword'
    wrong_password = 'nottestpassword'
    hash = Hashpasswd.createhash(correct_password)
    assert( Hashpasswd.validatepasswd( correct_password, hash ) == true, "correct password" )
    assert( Hashpasswd.validatepasswd( wrong_password, hash ) == false, "wrong password" )
    h1 = hash.split( Hashpasswd.getconstants[:DEFAULT_DELIMETER] )
    h2 = Hashpasswd.createhash( correct_password ).split( Hashpasswd.getconstants[:DEFAULT_DELIMETER] )
    assert( h1[Hashpasswd.getconstants[:HASH_INDEX]] != h2[Hashpasswd.getconstants[:HASH_INDEX]], "different hashes" )
    assert( h1[Hashpasswd.getconstants[:SALT_INDEX]] != h2[Hashpasswd.getconstants[:SALT_INDEX]], "different salt" )
  end

end
