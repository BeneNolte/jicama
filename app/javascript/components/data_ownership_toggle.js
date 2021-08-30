const initAutoFilter = () => {
  if (document.getElementById("customSwitch1")) {
    document.getElementById("customSwitch1").addEventListener("click", () => {
      document.getElementById('auto-submit').click();
    })
  }
};

export { initAutoFilter };
