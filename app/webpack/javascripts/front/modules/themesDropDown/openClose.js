module.exports = (nodes) => {
  let close = () => nodes.themesDropDown.classList.remove('_active');
  nodes.openThemesDropDown.onmouseenter = nodes.openThemesDropDown.onmouseleave  = (e) => {
    if (e.type === 'mouseenter') nodes.themesDropDown.classList.add('_active'); // Открываем меню
    if (e.type === 'mouseleave') { // Курсор ушел с тем
      // Если курсор ушел на меню выподающие меню или на меню с табами ничего не делать, иначе закрыть
      if(e.relatedTarget.closest('.js-themes-drop-down') || e.relatedTarget.closest('.question-menu__points')) return;
      close();
    }
  };
  nodes.menuQuesThemesDropDown.onmouseenter = nodes.menuQuesThemesDropDown.onmouseleave = (e) => {
    if (e.type === 'mouseleave') { // Курсор ушел с меню с табами
      // Если курсовр ушел на выподающие меню ничего не делает, иначе закрываем
      if (e.relatedTarget.closest('.js-menu-themes-drop-down')) return;
      close();
    }
  };
  nodes.menuThemesDropDown.addEventListener('mouseleave', close);
};
