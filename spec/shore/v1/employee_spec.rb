# frozen_string_literal: true

RSpec.describe Shore::V1::Employee do
  include_examples 'shore json api client' do
    let(:url) { 'https://api.shore.com/v1/employees' }
  end

  describe '#confirm_email' do
    subject { described_class.new(id: '11111111-1111-1111-1111-111111111111') }

    it 'performs a network request' do
      stub_request(:patch, "#{subject.url}/actions/confirm_email")
      subject.confirm_email
    end
  end

  describe '#resend_confirmation' do
    subject { described_class.new(id: '11111111-1111-1111-1111-111111111111') }

    it 'performs a network request' do
      stub_request(:patch, "#{subject.url}/actions/resend_confirmation")
      subject.resend_confirmation
    end
  end
end
