module VolunteerApp
  class SummonerNotFound < StandardError; end
  class RateLimited < StandardError; end
  class ServiceUnavailable < StandardError; end
end
