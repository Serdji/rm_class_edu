
module.exports = (nodes) => {
  let heightButton = nodes.button.offsetHeight;
  let heightWin    = window.innerHeight;
  let startCoord   = nodes.start.getBoundingClientRect().bottom - heightWin + heightButton;
  let stopCoord    = nodes.stop.getBoundingClientRect().bottom - heightWin;

  if ( startCoord <= 0 && stopCoord >= 0 ) {
    nodes.button.classList.remove('_stop');
    nodes.button.classList.add('_start');
  } else if ( startCoord >= 0 ) {
    nodes.button.classList.remove('_start');
  } else if ( stopCoord <= 0 ) {
    nodes.button.classList.add('_stop');
    nodes.button.classList.remove('_start');
  }
};
