const { declOfNum }  = require('utils'); // Склонятор
const count          = declOfNum()(['тема', 'темы', 'тем']);
const validationForm = require('./validationForm');

module.exports = (nodes ,arrVal, outputCounter, maxNumber) => {
  validationForm(nodes, arrVal, 1);
  let remainedTag = maxNumber - arrVal.length;
  outputCounter.innerText = `Осталось ${remainedTag} ${count(remainedTag)}`;
  if (arrVal.length === 0) outputCounter.innerText = `Можно добавить ${maxNumber} ${count(maxNumber)}`;
};
