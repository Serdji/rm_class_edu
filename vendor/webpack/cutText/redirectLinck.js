module.exports = (nodes) => {
  let originalText = nodes.biogDesc.innerHTML; // Сохраняем оригинальный текс
  let arrText      = originalText.split(' '); // Создаем массив из оригинального текта
  let limitation   = nodes.biogDesc.dataset.limitation; // Ставим лимит слов из data атрибута
  let href         = nodes.biography.querySelector('.js-questions-share-title').getAttribute('href');
  // Проверка на длину оригинального текста, если он меньше или равен лимита то удаляем ссылку и не обрезаем текст
  if (arrText.length <= limitation) {
    return;
  }
  // выризаем часть массив и копируем, разбиваем скопированный массив
  let cutText = `${arrText.slice(0, limitation).join(' ')} (
    <a href="${href}" class='similar-questions__detail js-desc-show _hover-underline'>Подробнее...</a>
  )`;
  nodes.biogDesc.innerHTML = cutText; // Полученный обрезанный текст вставляем в блок
}
