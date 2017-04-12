module.exports = nodes => {
  nodes.openSearch.addEventListener('touchend', () => {
    nodes.searchBlock.classList.remove('search_hidden');
    document.body.classList.add('_off-scroll'); // Отключаем скрол у body
    nodes.searchInput.focus();
  });

  nodes.closeSearch.addEventListener('touchend', (e) => {
    nodes.searchBlock.classList.add('search_hidden');
    nodes.searchInput.blur(); // скрывает клавиатуру
    document.body.classList.remove('_off-scroll'); // Включаем скрол у body
    e.stopPropagation();
  });
}
