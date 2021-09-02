import swal from 'sweetalert';

const initSweetalert = () => {

  const urlSearchParams = new URLSearchParams(window.location.search);
  const params = Object.fromEntries(urlSearchParams.entries());

  if (document.location.href.includes("dataprivacy=filter")) {
    swal("Auto-filter is activated, Your data privacy has improved!", {
      icon: "success",
      buttons: false,
    });
  } else if (document.location.href.includes("dataprivacy=restricted")) {
    swal(`${params.company} has now a restricted access to your personal data`, {
      icon: "success",
      buttons: false,
    });
  } else if (document.location.href.includes("dataprivacy=deleted")) {
    swal(`An email has been sent to ${params.company} to delete all the data they have on you`, {
      icon: "success",
      buttons: false,
    });
  } else if (document.location.href.includes("dataprivacy=allowed")) {
    swal(`${params.company} has now access to your data`, {
      icon: "info",
      buttons: false,
    });
  }

  const swalButton = document.getElementById("auto-filter");
  if (swalButton) { // protect other pages
    swalButton.addEventListener('click', () => {
      swal({
        title: "Activate auto-filter?",
        text: "Once activated and according to your preferences, the access to your personal data will be automatically restricted and emails will be sent to make sure companies will delete your infos",
      })
      .then((willDelete) => {
        if (willDelete) {
          document.getElementById('auto-submit').click();
        }
      });
    });
  }
  const buttonDone = document.querySelector(".done-button");
  if (buttonDone) { // protect other pages
    buttonDone.addEventListener('click', () => {
      swal('Done uploading your personal data', {
        icon: "success",
        buttons: false,
      });
    });
  }
};

export { initSweetalert };
