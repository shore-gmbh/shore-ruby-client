# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Shore::JsonApiClientExt::ComparableByTypeAndId do
  class MyComparable < OpenStruct
    include Shore::JsonApiClientExt::ComparableByTypeAndId
  end

  describe '#<=>' do
    let(:one) { MyComparable.new(type: 'b', id: 2) }
    subject { one <=> other }

    context 'when other is the same object' do
      let(:other) { one }
      it { is_expected.to equal(0) }
    end

    context 'when other has the same class, type and id' do
      let(:other) { MyComparable.new(type: one.type, id: one.id) }
      it { is_expected.to equal(0) }
    end

    context 'when other has different class, the same type and id' do
      let(:other) { OpenStruct.new(type: one.type, id: one.id) }
      it { is_expected.to equal(0) }
    end

    context 'when other has same type and id, but a different 3rd value' do
      let(:one) { MyComparable.new(type: 'b', id: 2, foo: :bar) }
      let(:other) { OpenStruct.new(type: one.type, id: one.id, foo: :other) }
      it { is_expected.to equal(0) }
    end

    context 'when other does not implement type' do
      let(:other) { OpenStruct.new(id: one.id) }
      it { is_expected.to be_nil }
    end

    context 'when other does not implement id' do
      let(:other) { OpenStruct.new(type: one.type) }
      it { is_expected.to be_nil }
    end

    context 'when the type is the same' do
      context "but other's id is ordered before" do
        let(:other) { OpenStruct.new(type: one.type, id: (one.id - 1)) }
        it { is_expected.to equal(1) }
      end
      context "but other's id is ordered after" do
        let(:other) { OpenStruct.new(type: one.type, id: (one.id + 1)) }
        it { is_expected.to equal(-1) }
      end
    end

    context 'when the type is different' do
      context "and other's type is ordered before" do
        let(:other) { OpenStruct.new(type: 'a', id: one.id) }
        it { is_expected.to equal(1) }
      end
      context "and other's type is ordered after" do
        let(:other) { OpenStruct.new(type: 'c', id: one.id) }
        it { is_expected.to equal(-1) }
      end
      context 'and id are different' do
        let(:other) { OpenStruct.new(type: 'c', id: one.id - 1) }
        it 'orders by type first and id second' do
          is_expected.to equal(-1)
        end
      end
    end
  end

  describe '#eql?' do
    let(:one) { MyComparable.new(type: 'b', id: 2) }
    subject { one.eql?(other) }

    context 'when other has the same class, type and id' do
      let(:other) { MyComparable.new(type: one.type, id: one.id) }
      it { is_expected.to equal(true) }
    end

    context 'when other has different class, the same type and id' do
      let(:other) { MyComparable.new(type: one.type, id: one.id) }
      it { is_expected.to equal(true) }
    end

    context 'when other has same type and id, but a different 3rd value' do
      let(:one) { MyComparable.new(type: 'b', id: 2, foo: :bar) }
      let(:other) { MyComparable.new(type: one.type, id: one.id, foo: :other) }
      it { is_expected.to equal(true) }
    end

    context 'when other type is different' do
      let(:other) { MyComparable.new(type: 'c', id: one.id) }
      it { is_expected.to equal(false) }
    end

    context 'when other id is different' do
      let(:other) { MyComparable.new(type: one.type, id: 3) }
      it { is_expected.to equal(false) }
    end

    context 'when other does not implement type' do
      let(:other) { MyComparable.new(id: one.id) }
      it { is_expected.to equal(false) }
    end
  end

  describe '#hash' do
    let(:one) { MyComparable.new(type: 'b', id: 2) }
    subject { one.hash }

    context 'when other has the same class, type and id' do
      let(:other) { MyComparable.new(type: one.type, id: one.id) }
      it { is_expected.to equal(other.hash) }
    end

    context 'when other has same type and id, but a different 3rd value' do
      let(:one) { MyComparable.new(type: 'b', id: 2, foo: :bar) }
      let(:other) { MyComparable.new(type: one.type, id: one.id, foo: :other) }
      it { is_expected.to equal(other.hash) }
    end

    context 'when other type is different' do
      let(:other) { MyComparable.new(type: 'c', id: one.id) }
      it { is_expected.to_not equal(other.hash) }
    end

    context 'when other id is different' do
      let(:other) { MyComparable.new(type: one.type, id: 3) }
      it { is_expected.to_not equal(other.hash) }
    end
  end
end
