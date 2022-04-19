HTMLWidgets.widget({

  name: 'ricv',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {
        if (x.css !== null && x.css !== undefined) {
          const styleSheet = document.createElement("style");
          let style = ""
          if (x.css.both !== null && x.css.both !== undefined) {
            const both = "#" + el.id + " .icv__label {" + x.css.both  + "}";
            style = style + both
          }
          if (x.css.before !== null && x.css.before !== undefined) {
            const before = "#" + el.id + " .icv__label-before {" + x.css.before  + "}";
            style = style + " " + before
          }
          if (x.css.after !== null && x.css.after !== undefined) {
            const after = "#" + el.id + " .icv__label-after {" + x.css.after  + "}";
            style = style + " " + after
          }
          styleSheet.innerText = style;
          el.parentNode.insertBefore(styleSheet, el);
        }
        const img1 = document.createElement("img");
        img1.src = x.img1;
        el.appendChild(img1);

        const img2 = document.createElement("img");
        img2.src = x.img2;
        el.appendChild(img2);

        const viewer = new ImageCompare(el, x.options).mount();
      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }

    };
  }
});
