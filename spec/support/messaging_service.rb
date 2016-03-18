def stub_success_request(message_id, auth_header)
  stub_request(:get, messaging_url(message_id))
    .with(correct_headers(auth_header))
    .to_return(correct_response(message_id))
end

def stub_not_authorized_request(message_id)
  stub_request(:get, messaging_url(message_id))
    .to_return(status: 401)
end

def stub_not_found_request(message_id, auth_header)
  stub_request(:get, messaging_url(message_id))
    .with(correct_headers(auth_header))
    .to_return(status: 404)
end

def correct_headers(auth_header)
  {
    headers: {
      'Authorization' => auth_header,
      'Content-Type' => 'application/vnd.api+json'
    }
  }
end

def correct_response(message_id)
  {
    headers: { content_type: 'application/vnd.api+json' },
    body: {
      data: {
        type: 'messages',
        id: message_id,
        attributes: { content: 'Test message' }
      }
    }.to_json
  }
end

def messaging_url(message_id)
  "#{Shore::Client::Messaging.base_uri(:v1)}/messages/#{message_id}"
end
