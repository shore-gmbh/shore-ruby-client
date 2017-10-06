# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Shore::JsonApiClientExt::WithMeta do
  class MyResource < JsonApiClient::Resource
    include Shore::JsonApiClientExt::WithMeta
  end

  describe '.with_meta' do
    it 'sets `custom_meta` during the block' do
      meta = { 'a' => 'b', 'c' => 'd' }
      MyResource.with_meta(meta) do
        expect(MyResource.custom_meta).to eq(meta)
      end
    end

    it 'resets `custom_meta` after the block' do
      meta = { 'a' => 'b', 'c' => 'd' }
      MyResource.with_meta(meta) do
      end
      expect(MyResource.custom_meta).to be_nil
    end

    it 'resets `custom_meta` after the block even if error is raised' do
      meta = { 'a' => 'b', 'c' => 'd' }
      expect do
        MyResource.with_meta(meta) do
          raise StandardError
        end
      end.to raise_error(StandardError)
      expect(MyResource.custom_meta).to be_nil
    end
  end

  describe '#as_json_api' do
    it 'merges the `custom_meta` into result from super' do
      meta = { 'a' => 'b', 'c' => 'd' }
      MyResource.with_meta(meta) do
        expect(MyResource.new(id: 'the-id', one: 'two').as_json_api)
          .to eq('id' => 'the-id',
                 'type' => 'my_resources',
                 'attributes' => { 'one' => 'two' },
                 'meta' => { 'a' => 'b', 'c' => 'd' })
      end
    end
  end
end
