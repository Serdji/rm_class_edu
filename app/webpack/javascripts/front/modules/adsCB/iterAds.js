const ban100x240    = require('./ban_100х240');
const banDirect     = require('./ban_direct');
const { each, qs }  = require('utils');

module.exports = (nodes) => {
  // Реклама на главной странице и странице выдачи
  if (!qs('.js-tag-ads') || qs('.js-page-root')) {
    let index;
    each(nodes.questionsAds, (el, i) => {
      if (i === 1) ban100x240(el, i);
      if (i > 3 && i % 4 === 0) banDirect(el, i + 1);
      else if (nodes.questionsAds.length === i + 1 && nodes.searchPagAds) banDirect(nodes.searchPagAds, i + 1);
    });
    if (nodes.rootBanDirect) banDirect(nodes.rootBanDirect, index);
    if (!qs('.js-questions-ads')) banDirect(nodes.searchPagAds, index);
  } else if (!qs('.js-page-temys-ads') && !qs('.js-page-temy-ads') && !qs('.js-page-question-ads')) {
    each(nodes.tagAds, (el, i) => {
      if (i === 3) ban100x240(el, i);
      if (i > 9 && i % 9 === 0) banDirect(el, i + 1);
      else if (nodes.tagAds.length === i + 1 && nodes.searchPagAds) banDirect(nodes.searchPagAds, i + 1);
    });
  }

  // Реклама на странице тем
  if (qs('.js-page-temys-ads')) {
    each(nodes.tagAds, (el, i) => {
      if (i === 5) ban100x240(el, i);
      if (i > 10 && i % 5 === 0) banDirect(el, i + 1);
      else if (nodes.tagAds.length === i + 1 && nodes.temyPagAds) banDirect(nodes.temyPagAds, i + 1);
    });
  }

  // Реклама на странице вопроса
  if (qs('.js-your-answer-ads')) {
    let index;
    ban100x240(qs('.js-your-answer-ads'), 1);
    if (nodes.questionsAds) {
      each(nodes.questionsAds, (el, i) => {
        index = i + 1;
        if (i > 3 && i % 4 === 0) banDirect(el, index);
        else if (nodes.questionsAds.length === index) banDirect(el, index);
      });
    }
    if (nodes.questionsAds.length === 0) banDirect(nodes.similarThemesAds, ++index);
  }

  //Реклама на странице темы
  if (qs('.js-page-temy-ads')) {
    let index;
    each(nodes.questionsAds, (el, i) => {
      index = i + 1;
      if (i === 1) ban100x240(el, i);
      if (i > 3 && i % 4 === 0) banDirect(el, index );
    });
    if (nodes.temyBanDirect) banDirect(nodes.temyBanDirect, ++index);
  }
};
