# frozen_string_literal: true

class PermissionModuleTypeEnum < EnumerateIt::Base
  associate_values(
    post: 1
  )

  def self.name_ordered
    to_a
      .map { |name, id| { id: id, name: name } }
      .sort_by { |object| object[:name] }
  end

  sort_by :value
end
