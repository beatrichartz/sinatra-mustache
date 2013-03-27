module FakeTemplateHelper
  def name first_name, last_name
    [first_name, last_name].join ' '
  end
  def friends *friends
    friends.join ' & '
  end
  def sour_drink type
    "#{type} Sour"
  end
  def random_drink
    "Beer"
  end
end