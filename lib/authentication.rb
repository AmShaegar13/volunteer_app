class Authentication
  attr_accessor :success, :code, :error, :user

  def initialize(params)
    uri = URI.parse(Resources['auth_service']['url'])
    response = Net::HTTP.post_form uri, params
    result = JSON(response.body)
    self.success = result['success']
    self.code = result['code']
    self.error = result['error']
    self.user = HashWithIndifferentAccess.new(result['user'])
  end

  alias_method :success?, :success
end