module SocialShares
  class Facebook < Base
    URL = 'http://graph.facebook.com/v2.8/'

    def shares!
#      response = get(URL, params: {
#        id: checked_url,
#        fields: 'share'
#      })

      response = RestClient::Resource.new(URL, timeout: TIMEOUT, open_timeout: OPEN_TIMEOUT).get(params: {
        id: checked_url,
        fields: 'share'
      }){ |resp, request, result, &block|
        case resp.code
          when 200
            resp
          else
            puts resp
            raise
        end
      }

      json_response = JSON.parse(response)

      if json_response['share']
        json_response['share']['share_count'] || 0
      else
        0
      end
    end
  end
end
