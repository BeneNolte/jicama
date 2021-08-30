import flatpickr from "flatpickr";

const initFlatpickr = () => {
  flatpickr(".datepicker", {});
  console.log("Hello");
}

export { initFlatpickr };
