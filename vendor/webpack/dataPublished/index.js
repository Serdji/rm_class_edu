const moment = require('moment');
require('moment/locale/ru');
const { each } = require('utils');

moment.locale('ru', {
  calendar: {
    sameDay: '[Сегодня,] LT',
    lastDay: '[Вчера,] LT',
  }
});

module.exports = nodes => {
  each(nodes.dataPublished, el => {
    // Дата публикации
    let dateTimeCreation = el.dataset.publishedAt;
    // Если год совпадает выводить дату в формате (дата, месяц)
    if (moment().year() === moment(dateTimeCreation).year()) {
      // Если совпадает месяц
      if (moment().month() === moment(dateTimeCreation).month()) {
        // Если сегодня, выводим в формате (Сегодня, время)
        if (moment().date() === moment(dateTimeCreation).date()) el.innerText = moment(dateTimeCreation).calendar();
        // Если вчера, выводим в формате (Вчера, время)
        if ((moment().date() - 1) === moment(dateTimeCreation).date()) el.innerText = moment(dateTimeCreation).subtract().calendar();
        // В остальные дни выводим в формате (дата, месяц)
        if ((moment().date() - 1) > moment(dateTimeCreation).date()) el.innerText = moment(dateTimeCreation).format('D MMMM');
      } else {
        // Если месяц не совпал всегда выводим в формате (дата, месяц)
        el.innerText = moment(dateTimeCreation).format('D MMMM');
      }
    } else {
      // Если дата побликации прошлогодняя, выводим в формате (дата, месяц, год)
      el.innerText = moment(dateTimeCreation).format('D MMMM YYYY');
    }
  });
};
