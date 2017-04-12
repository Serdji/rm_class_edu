const { declOfNum } = require('utils'); // Склонятор
const count         = declOfNum()(['тема', 'темы', 'тем']);

module.exports = (nodes, arrVal, maxTag) => {
  let remainedTag = maxTag - arrVal.length;
  nodes.maxLengthCounterSelect.innerText = `Осталось ${remainedTag} ${count(remainedTag)}`;
  if (arrVal.length === 0) nodes.maxLengthCounterSelect.innerText = `Можно добавить ${maxTag} ${count(maxTag)}`;
};
