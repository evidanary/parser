#General cheat class with fields for what goes in a cheat
# At the core a cheat comprises of
# 1. A category (a region in the cheatsheet/category such as git, vim)
# 2. A description (which is short)
# 3. The command (which is a one liner)


class Cheat
  attr_accessor :category, :description, :command

end
