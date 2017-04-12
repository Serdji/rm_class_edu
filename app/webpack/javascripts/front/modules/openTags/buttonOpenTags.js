const { each, getCoords } = require('utils');

module.exports = nodes => {
  // Проходим по всем нодам где есть теги циклом
  each(nodes.hashTags, el => {
    // Как эталон координат выделяем первый элемент в массиве
    let standardTop = getCoords(el.childNodes[0]).top;
    let arrNodes    = [];
    // Проходимся циклом по всем дочерним элементам
    each(el.childNodes, child => {
      // Сохраняем все координаты элементов
      let childTop = getCoords(child).top;
      // Добавляем в массив только те эементы, координаты которых привешают этолон
      if (childTop > standardTop+10) arrNodes.push(child);
    });
    // Из массива заберам только первый эелемент. Этот элемент и есть первый кто переноситься на новою страку
    let firstTag = arrNodes[0];
    // Сколько спрятано эелементов (тегов)
    let sizeTag  = arrNodes.length;
    // Шаблон кнопки тега
    let tag      = `
      <div class='question-common__point js-point-tags js-open-tags'>
        <span>+${sizeTag}</span>
      </div>
    `;
    // Если нет переноса элемента, останавливаем скрипт
    if (!firstTag) return;
    // Вставляем шаблон, перд первым скрытым элементом
    firstTag.insertAdjacentHTML('beforeBegin', tag);
    // Условие если кнопка-тег не поместилось с открытми элементами
    // Берем скрытую кнопку-тег и ее координаты
    let buttonTag    = firstTag.previousElementSibling;
    let buttonTagTop = getCoords(buttonTag).top;
    // Проверяем, если кнопка-тег переша на другую строчку и исчезла
    if (buttonTagTop > standardTop) {
      // Собираем все нужные нас css свойства для вычисления
      let hashTags       = firstTag.closest('.js-hash-tags');
      let widthButtonTag = parseInt(getComputedStyle(buttonTag).width, 10);
      let prButtonTag    = parseInt(getComputedStyle(buttonTag).paddingRight, 10) * 2;
      let widthHashTags  = parseInt(getComputedStyle(hashTags).width, 10);
      // Высчитываем получившиеся значения и расширяем hash с тегами до появления кнопки тега
      hashTags.style.width = `${widthButtonTag + widthHashTags + prButtonTag}px`;
    }
  });
};
