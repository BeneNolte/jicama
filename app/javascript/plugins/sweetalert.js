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


  const inputButton = document.getElementById("datasource_file")
  const uploadButton = document.getElementById("uploadfile")
  if (uploadButton) { // protect other pages
    uploadButton.addEventListener('click', () => {
      if (inputButton.value != "") {
        swal({
          icon: "https://cdn.dribbble.com/users/600626/screenshots/2944614/loading_12.gif",
          title: "don't leave this page !",
          text: "Uploading your personal data to Jicama, it might take some time",
          closeOnClickOutside: false,
          buttons: false,
        })
      }
    });
    if (document.location.href.includes("uploaded_file=false")) {
      swal("You need to upload a file!", {
        icon: "info",
        buttons: false,
      });
    }
  }

  if (document.location.href.includes("uploaded_file=done")) {
    swal({
      icon: "success",
      text: "your data has been successfully downloaded !",
      buttons: false,
    })
  }
  

  // const buttonDone = document.querySelector(".done-button");
  // if (buttonDone) { // protect other pages
  //   buttonDone.addEventListener('click', () => {
  //     swal('Done uploading your personal data', {
  //       icon: "success",
  //       buttons: false,
  //     });
  //   });
  // }
};

export { initSweetalert };
