import swal from 'sweetalert';

const initSweetalert = () => {

  if (document.location.href.includes("autofilter=true")) {
    swal("Your data privacy has improved!", {
      icon: "success",
    });
  }

  const swalButton = document.getElementById("auto-filter");
  if (swalButton) { // protect other pages
    swalButton.addEventListener('click', () => {
      swal({
        title: "Activate auto-filter?",
        text: "Once activated and according to your preferences, the access to your personal data will be automatically restricted and emails will be sent to make sure companies will delete your infos",
        buttons: true,
        dangerMode: true,
      })
      .then((willDelete) => {
        if (willDelete) {
          document.getElementById('auto-submit').click();
        }
      });
    });
  }
};

export { initSweetalert };


