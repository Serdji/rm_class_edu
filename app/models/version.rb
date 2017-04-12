class Version < PaperTrail::Version
  belongs_to :employee, foreign_key: :whodunnit
end
