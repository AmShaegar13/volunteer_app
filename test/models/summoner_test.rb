require 'test_helper'
require 'active_resource/http_mock'

class SummonerTest < ActiveSupport::TestCase
  def setup
    api_result_amshaegar = <<-EOF
{"amshaegar": {
   "id": 19572542,
   "name": "AmShaegar",
   "profileIconId": 716,
   "revisionDate": 1416672092000,
   "summonerLevel": 30
}}
EOF

    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/lol/euw/v1.4/summoner/by-name/amshaegar?api_key=secret_api_key',    {}, api_result_amshaegar
      mock.get '/api/lol/euw/v1.4/summoner/by-name/NoNeXiStEnT?api_key=secret_api_key',  {}, nil, 404
      mock.get '/api/lol/euw/v1.4/summoner/by-name/rate_limited?api_key=secret_api_key',    {}, nil, 429
      mock.get '/api/lol/euw/v1.4/summoner/by-name/server_error?api_key=secret_api_key',    {}, nil, 500
      mock.get '/api/lol/euw/v1.4/summoner/by-name/unavailable?api_key=secret_api_key',    {}, nil, 503
    end
  end

  test 'should find summoner' do
    summoner = Summoner.find_by! name: 'amshaegar', region: 'euw'
    assert_equal 19572542, summoner.id
    assert_equal 'AmShaegar', summoner.name
    assert_equal 30, summoner.summonerLevel
  end

  test 'should not find summoner' do
    assert_raises VolunteerApp::SummonerNotFound do
      Summoner.find_by! name: 'NoNeXiStEnT', region: 'euw'
    end
  end

  test 'should fail with rate limited' do
    assert_raises VolunteerApp::RateLimited do
      Summoner.find_by! name: 'rate_limited', region: 'euw'
    end
  end

  test 'should fail with api server error' do
    assert_raises ActiveResource::ServerError do
      Summoner.find_by! name: 'server_error', region: 'euw'
    end
  end

  test 'should fail with api unavailable' do
    assert_raises VolunteerApp::ServiceUnavailable do
      Summoner.find_by! name: 'unavailable', region: 'euw'
    end
  end
end
