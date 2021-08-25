const initAutoFilter = () => {
  document.getElementById("customSwitch1").addEventListener("click", () => {
    document.getElementById("auto-filter-form").submit();
  })
};

export { initAutoFilter };
