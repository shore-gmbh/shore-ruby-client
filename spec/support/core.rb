def stub_core_success_request(merchant_account_id, auth_header)
  stub_request(:get, core_url)
    .with(correct_headers(auth_header))
    .to_return(correct_core_response(merchant_account_id))
end

def stub_core_not_authorized_request
  stub_request(:get, core_url)
    .to_return(status: 401)
end

def correct_core_response(merchant_account_id)
  {
    headers: { content_type: 'application/vnd.api+json' },
    body: {
      data: [
        type: 'merchant_accounts',
        id: merchant_account_id,
        attributes: { display_name: 'Test', name: 'Test', email: 't@test.com' }
      ]
    }.to_json
  }
end

def core_url
  "#{Shore::Client::Services.url_for(:core, :v1)}/merchant_accounts"
end
