const { qs } = require('utils');

if (qs('.js-lading')) {
  let title = '<span>Встречайте совсем скоро!</span>';

  let text = `<span>Рамблер/класс — проект, который поможет найти ответы на любые вопросы школьников, родителей и преподавателей, касающиеся образования и не только:</span>
              <ul>
                <li>— Как сдать ЕГЭ и остаться в живых?</li>
                <li>— ГДЗ: вред или польза?</li>
                <li>— Дочь влюблена в учителя – что делать?</li>
                <li>— Как выбрать платье на выпускной?</li>
                <li>— Школьная форма: за и против?</li>
              </ul>
              <span>Совсем скоро ответы на эти и другие вопросы на Рамблер/класс.</span>`;

  let footer = `<div class="landing__content-connection">
                  <span>Свяжитесь с нами:</span>
                  <a href="mailto:class-support@rambler-co.ru">class-support@rambler-co.ru</a>
                </div>`;

  qs('.js-lading-title').insertAdjacentHTML('beforeEnd', title);
  qs('.js-lading-text').insertAdjacentHTML('beforeEnd', text);
  qs('.js-lading-footer').insertAdjacentHTML('beforeEnd', footer);
}
