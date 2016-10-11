module SocialShares
  class Facebook < Base
    URL = 'https://graph.facebook.com/v2.8/'
    @@access_token = nil

    def self.set_access_token( app_id, app_secret )
       @@access_token = "#{app_id}|#{app_secret}"
    end

    def shares!
      params = { id: checked_url, fields: 'share' }
      params[:access_token] = @@access_token unless @@access_token.nil? 

#      response = get(URL, params: {
#        id: checked_url,
#        fields: 'share'
#      })

      response = RestClient::Resource.new(URL, timeout: TIMEOUT, open_timeout: OPEN_TIMEOUT).get(params: params){ |resp, request, result, &block|
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
