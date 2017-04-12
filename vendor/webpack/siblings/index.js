module.exports = function(elem, dir) {
  if (!elem) return false;
  let sibling = elem;
  this.nextSibling = [];
  this.previousSibling = [];

  let nodeIterator = (name) => {
    while (sibling[name]) {
      sibling = sibling[name];
      sibling.nodeType === 1 && this[name].push(sibling);
    }
  };

  if (dir === '<' || !dir) { nodeIterator('previousSibling'); sibling = elem;}
  if (dir === '>' || !dir) { nodeIterator('nextSibling'); }

  return this.nextSibling.concat(this.previousSibling);
};
