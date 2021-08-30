const autoFilter = () => {
  const autof_btn = document.querySelector('#auto-filter-form');
  autof_btn.addEventListener('click', (event) => {
    console.log(event);
  });
}

export { autoFilter };
