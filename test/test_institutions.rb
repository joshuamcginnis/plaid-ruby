require_relative 'test_helper'

# Internal: The test for Plaid::Institutions.
class PlaidInstitutionsTest < PlaidTest
  def test_get
    response = client.institutions.get(count: 3, offset: 1)
    assert_equal(3, response.institutions.length)
  end

  def test_get_with_options
    response = client.institutions.get count: 3,
                                       offset: 1,
                                       options: { products: ['transactions'] }
    assert_equal(3, response['institutions'].length)
  end

  def test_get_invalid_parameters
    assert_raises(Plaid::InvalidRequestError) do
      client.institutions.get(count: BAD_STRING, offset: BAD_STRING)
    end
  end

  def test_get_by_id
    response = client.institutions.get_by_id(SANDBOX_INSTITUTION)
    assert_equal(SANDBOX_INSTITUTION, response.institution.institution_id)
  end

  def test_get_by_id_with_options
    options = { include_display_data: true }
    response = client.institutions.get_by_id(SANDBOX_INSTITUTION,
                                             options: options)
    assert_equal(SANDBOX_INSTITUTION_NAME,
                 response['institution'][:brand_name])
  end

  def test_get_by_id_invalid_parameters
    assert_raises(Plaid::InvalidInputError) do
      client.institutions.get_by_id(BAD_STRING)
    end
  end

  def test_search
    response = client.institutions.search(SANDBOX_INSTITUTION_NAME)
    refute_empty(response.institutions)
  end

  def test_search_with_products
    response = client.institutions.search SANDBOX_INSTITUTION_NAME,
                                          [:transactions]
    refute_empty(response.institutions)
  end

  def test_search_invalid_products
    assert_raises(Plaid::InvalidInputError) do
      client.institutions.search(SANDBOX_INSTITUTION_NAME, BAD_ARRAY)
    end
  end

  def test_search_bad_products
    assert_raises(Plaid::InvalidInputError) do
      client.institutions.search(SANDBOX_INSTITUTION_NAME, BAD_STRING)
    end
  end
end
