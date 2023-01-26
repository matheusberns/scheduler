# frozen_string_literal: true

class FreightTypeEnum < EnumerateIt::Base
  associate_values(
    cif: 1,
    fob: 2,
    cif_redispatch: 3
  )

  sort_by :value
end
