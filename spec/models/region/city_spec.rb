# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Region::City, type: :model do
  describe 'Table' do
    it 'should have table name translations' do
      expect(I18n.exists?('activerecord.models.city.one')).to be_truthy, 'Column translation missing: City(:one)'
      expect(I18n.exists?('activerecord.models.city.other')).to be_truthy, 'Column translation missing: City(:other)'
    end

    columns = %i[name
                 state_id
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
                            created_by_id
                            deleted_at
                            name
                            state_id
                            updated_by_id]

    columns_with_index.each do |column|
      it { should have_db_index(column) }
    end

    it 'columns translations' do
      columns.each do |column|
        expect(I18n.exists?("activerecord.attributes.city.#{column}")).to be_truthy,
                                                                          "Column translation missing: #{column}"
      end
    end
  end

  describe 'ActiveStorage attachments' do
  end

  describe 'Belongs_to associations' do
    it {
      should belong_to(:state).conditions(active: true).class_name('::Region::State').inverse_of(:cities)
                              .with_foreign_key(:state_id)
    }
  end

  describe 'Has_many associations' do
  end

  describe 'Scopes' do
    it 'list' do
      expect(::Region::City.list).to be_an_scope_attributes
    end

    it 'by_search' do
      expect(::Region::City.by_search(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'by_name' do
      expect(::Region::City.by_name(::Faker::Name.name)).to be_an_scope_attributes
    end

    it 'by_state_id' do
      expect(::Region::City.by_state_id(::FactoryBot.create(:state)&.id)).to be_an_scope_attributes
    end

    it 'by_id' do
      expect(::Region::City.by_id(::Faker::Number.digit)).to be_an_scope_attributes
    end
  end

  describe 'class validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
  end

  describe 'Methods' do
  end
end
