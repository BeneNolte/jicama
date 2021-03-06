// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";
import { initMapbox } from '../plugins/init_mapbox';
import { initFlatpickr } from "../plugins/flatpickr";

// Internal imports
import { initAutoFilter } from '../components/data_ownership_toggle';

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
import { dataInsightCard } from "../pages/datasource";
import { initUpdateNavbarOnScroll } from "../components/navbar";
import { initBottombar } from "../components/bottombar"
import { initPopover } from "../components/popover"
import { initSweetalert } from "../plugins/sweetalert"
import { logoHome } from "../pages/home"
import { uploadButton } from "../pages/tuto"

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();

  initAutoFilter();
  dataInsightCard();
  initUpdateNavbarOnScroll();
  initBottombar();
  initMapbox();
  initFlatpickr();
  initPopover();
  initSweetalert();
  logoHome();
  uploadButton();
});
