# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Region::State, type: :model do
  describe 'Table' do
    it 'should have table name translations' do
      expect(I18n.exists?('activerecord.models.state.one')).to be_truthy, 'Column translation missing: State(:one)'
      expect(I18n.exists?('activerecord.models.state.other')).to be_truthy, 'Column translation missing: State(:other)'
    end

    columns = %i[uf
                 country
                 created_by_id
                 updated_by_id
                 active
                 deleted_at
                 created_at
                 updated_at]

    columns.each do |column|
      it { should have_db_column(column) }
    end

    columns_with_index = %i[active
                            country
                            created_by_id
                            deleted_at
                            uf
                            updated_by_id]

    columns_with_index.each do |column|
      it { should have_db_index(column) }
    end

    it 'columns translations' do
      columns.each do |column|
        expect(I18n.exists?("activerecord.attributes.state.#{column}")).to be_truthy,
                                                                           "Column translation missing: #{column}"
      end
    end
  end

  describe 'ActiveStorage attachments' do
  end

  describe 'Belongs_to associations' do
  end

  describe 'Has_many associations' do
    it { should have_many(:cities).class_name('::Region::City').inverse_of(:state).with_foreign_key(:state_id) }
  end

  describe 'Scopes' do
    it 'list' do
      expect(::Region::State.list).to be_an_scope_attributes
    end

    it 'by_uf' do
      expect(::Region::State.by_uf(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'by_search' do
      expect(::Region::State.by_search(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'by_id' do
      expect(::Region::State.by_id(::Faker::Number.digit)).to be_an_scope_attributes
    end
  end

  describe 'class validations' do
    it { should validate_presence_of(:uf) }
    it { should validate_length_of(:uf).is_at_most(255) }
  end

  describe 'Methods' do
  end
end
