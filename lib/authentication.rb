require 'digest/sha1'

class Authentication
  attr_accessor :success, :code, :error, :user

  def initialize(params)
    self.success = params['login'].downcase == 'admin' && Digest::SHA1.hexdigest(params['password']) == ENV['ADMIN_PASSWORD']
    self.user = {
      id: 1,
      name: 'Admin'
    }
  end

  alias_method :success?, :success
end