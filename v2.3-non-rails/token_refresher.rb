require 'aws_msk_iam_sasl_signer'

class OAuthTokenRefresher
  def on_oauthbearer_token_refresh(event)
    puts "event: #{event.inspect}"
    signer = AwsMskIamSaslSigner::MSKTokenProvider.new(region: 'us-east-1')
    token = signer.generate_auth_token

    event[:bearer].oauthbearer_set_token(
      token: token.token,
      lifetime_ms: token.expiration_time_ms,
      principal_name: 'kafka-cluster'
    )
  end
end

