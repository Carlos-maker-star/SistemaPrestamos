"use strict";
$("#modeSwitcher").on("click", function (e) {
  e.preventDefault(), modeSwitch(), location.reload();
});
