class MenuService
  def initialize(controller)
    @controller = controller
  end

  def root_class
    '_activ' if current_controller_is('home')
  end

  def library_class
    '_activ' if current_controller_is('library', 'textbooks')
  end

  private

  def current_controller_is(*names)
    names.include?(@controller.controller_name)
  end
end
