const { each } = require('utils');

module.exports = (nodes) => {

  each(nodes.locationComplaint, el =>{
    el.addEventListener('click', locationComplaint);
    function locationComplaint() {
      let url = this.closest('[data-complaint]').dataset.complaint;
      window.location = url;
    }
  });
};
