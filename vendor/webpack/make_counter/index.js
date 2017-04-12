module.exports = (() => {
  let currentCount = 1;
  return {
    getNext() {
      return currentCount++;
    },
    getPrev() {
      return currentCount--;
    },
    get() {
      return currentCount;
    },
    set(numberPage) {
      currentCount = numberPage;
    },
    reset() {
      currentCount = 1;
    },
  };
})();
