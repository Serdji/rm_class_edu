module.exports = () => {
  let cases = [2, 0, 1, 1, 1, 2];
  let declOfNumSubFunction = function(titles, number) {
    number = Math.abs(number);
    return titles[ (number % 100 > 4 && number % 100 < 20 ) ? 2 : cases[ ( number % 10 < 5) ? number % 10 : 5] ];
  };
  return function(_titles) {
    if ( arguments.length === 1 ) {
      return function(_number) {
        return declOfNumSubFunction(_titles, _number);
      };
    } else {
      return declOfNumSubFunction.apply(null, arguments);
    }
  };
}
