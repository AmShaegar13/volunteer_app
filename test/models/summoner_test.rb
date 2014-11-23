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
      mock.get '/api/lol/euw/v1.4/summoner/by-name/NoNeXiStEnT?api_key=secret_api_key',  {}, nil, 404
      mock.get '/api/lol/euw/v1.4/summoner/by-name/amshaegar?api_key=secret_api_key',    {}, api_result_amshaegar
    end
  end

  test 'should find summoner' do
    summoner = Summoner.find_by! name: 'amshaegar', region: 'euw'
    assert_equal 19572542, summoner.id
    assert_equal 'AmShaegar', summoner.name
    assert_equal 30, summoner.summonerLevel
  end

  test 'should not find summoner' do
    assert_raises ActiveResource::ResourceNotFound do
      Summoner.find_by! name: 'NoNeXiStEnT', region: 'euw'
    end
  end
end
