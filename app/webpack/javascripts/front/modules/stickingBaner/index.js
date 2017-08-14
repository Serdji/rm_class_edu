const stickyBlock = require('stickyBlock');
const { qs }      = require('utils');

module.exports = () => {

  if ( qs('.js-float-wrapper')){
    let nodes = {
      wrapper: qs('.js-float-wrapper'),
      leftSidebar: qs('.js-left-sidebar'),
      rightSidebar: qs('.js-right-sidebar')
    };


      let wrapperH      = nodes.wrapper.offsetHeight;
      let leftSidebarH  = nodes.leftSidebar.offsetHeight + parseInt(getComputedStyle(nodes.leftSidebar).marginBottom, 10);

      let rightSidebarH = nodes.rightSidebar.offsetHeight + parseInt(getComputedStyle(nodes.rightSidebar).marginBottom, 10);
      if ( wrapperH > leftSidebarH ) stickyBlock('.js-float-left-sidebar', '.js-float-wrapper');
      if ( wrapperH > rightSidebarH ) stickyBlock('.js-float-right-sidebar', '.js-float-wrapper', true);
    }

};
