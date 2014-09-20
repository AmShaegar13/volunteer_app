class Authentication
  attr_accessor :success, :code, :error

  def initialize(params)
    uri = URI.parse(Resources.data['auth_service']['url'])
    response = Net::HTTP.post_form uri, params
    result = JSON(response.body)
    self.success = result['success']
    self.code = result['code']
    self.error = result['error']
  end

  alias_method :success?, :success
end