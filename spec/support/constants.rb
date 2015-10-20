#####################
# holder of test equivalents of all values found in recipes
# should be replaced by library referenced by recipes and unit tests
#####################
module Recipe
  # copies of string literals found in recipe
  module Literal
    SERVICE = 'oracle-inventory'
  end
  # test values to be assigned to attributes the recipe will use
  module Attributes
    BASEDIR = '/test/oracle-inventory'

    def self.setup(node)
      node.set['oracle-inventory']['basedir'] = BASEDIR
    end
  end
  # copies of values calculated by recipe or libraries
  module Derived
  end
end
