require('./style.css');

module.exports = (sidebar, content, fixTop = false, spaceTop = 0) => {

  let a = document.querySelector(sidebar);
  let b = null;
  let K = null;
  let Z = 0;
  let P = spaceTop;  // если у P ноль заменить на число, то блок будет прилипать до того, как верхний край окна браузера дойдёт до верхнего края элемента,
  let N = 0; // если у N — нижний край дойдёт до нижнего края элемента. Может быть отрицательным числом

  window.addEventListener('scroll', Ascroll, false);

  function Ascroll() {

    let Ra       = a.getBoundingClientRect();
    let R1bottom = document.querySelector(content).getBoundingClientRect().bottom;

    if (Ra.bottom < R1bottom) {

      if (b === null) {

        b = document.createElement('div');
        b.className = "stop";
        b.style.cssText = 'width: ' + a.offsetWidth + 'px;';
        a.insertBefore(b, a.firstChild);

        let l = a.childNodes.length;

        for (let i = 1; i < l; i++) {
          b.appendChild(a.childNodes[1]);
        }

      }

      let Rb  = b.getBoundingClientRect();
      let Rh  = Ra.top + Rb.height;
      let W   = document.documentElement.clientHeight;
      let R1  = Math.round(Rh - R1bottom);
      let R2  = Math.round(Rh - W);

      // Если fixTop = true то блок приклееваться только к верху экрана
      let Tbf = fixTop ? Rb.top + N : Rb.bottom - W + N;
      let Bb  = fixTop ? (R2 - (Rb.height - W )) + N : R2 + N;
      let St  = fixTop ? N + 'px' : W - Rb.height - N + 'px';
      // --------------------------------------------------------------

      if (Rb.height > W) {
        if (Ra.top < K) {  // скролл вниз
          if (Bb > R1) {  // не дойти до низа;
            if (Tbf < 1) {  // подцепиться
              b.className = 'sticky';
              b.style.top = St;
              Z = N + Ra.top + Rb.height - W;
            } else {
              b.className = 'stop';
              b.style.top = -Z + 'px';
            }
          } else {
            b.className = 'stop';
            b.style.top = -R1 + 'px';
            Z = R1;
          }
        } else {  // скролл вверх
          if ((Ra.top - P) <= 0) {  // не дойти до верха
            if ((Rb.top - P) >= 0) {  // подцепиться
              b.className = 'sticky';
              b.style.top = P + 'px';
              Z = Ra.top - P;
            } else {
              b.className = 'stop';
              b.style.top = -Z + 'px';
            }
          } else {
            b.className = '';
            b.style.top = '';
            Z = 0;
          }
        }
        K = Ra.top;
      } else {
        if ((Ra.top - P) <= 0) {
          if ((Ra.top - P) <= R1) {
            b.className = 'stop';
            b.style.top = -R1 + 'px';
          } else {
            b.className = 'sticky';
            b.style.top = P + 'px';
          }
        } else {
          b.className = '';
          b.style.top = '';
        }
      }

      window.addEventListener('resize', function () {
        a.children[0].style.width = getComputedStyle(a, '').width
      }, false);
    }
  }
};
