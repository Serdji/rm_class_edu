module.exports = nodes => {
  nodes.search.addEventListener('click', (e) => {
    let target = e.target;
    // Дилегируем событие и в зависимости от класса, оправляем данные в счетчик
    if (target.closest('.js-clear-input')) yaCounter38595795.reachGoal('click_krest');
    if (target.closest('.js-search-question')) yaCounter38595795.reachGoal('click_element_question');
    if (target.closest('.js-search-theme')) yaCounter38595795.reachGoal('click_element_tag');
    if (target.closest('.js-search-result')) yaCounter38595795.reachGoal('click_link_all_results');
    if (target.closest('.js-search-search')) yaCounter38595795.reachGoal('click_global_search');
    if (target.closest('.js-clear-button')) yaCounter38595795.reachGoal('click_create_button_issue');
  });
};
