module.exports = nodes => {
  nodes.search.addEventListener('click', (e) => {
    if (window.yaCounter43407474) {
      let target = e.target;
      // Дилегируем событие и в зависимости от класса, оправляем данные в счетчик
      if (target.closest('.js-clear-input')) yaCounter43407474.reachGoal('click_krest');
      if (target.closest('.js-search-question')) yaCounter43407474.reachGoal('click_element_question');
      if (target.closest('.js-search-theme')) yaCounter43407474.reachGoal('click_element_tag');
      if (target.closest('.js-search-result')) yaCounter43407474.reachGoal('click_link_all_results');
      if (target.closest('.js-search-search')) yaCounter43407474.reachGoal('click_global_search');
      if (target.closest('.js-clear-button')) yaCounter43407474.reachGoal('click_create_button_issue');
    }
  });
};
