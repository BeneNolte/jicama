const uploadButton = () => {
  const choose = document.querySelector(".upload-button")
  const done = document.querySelector('input[name="commit"]')
  const inputButton = document.getElementById("datasource_file")

  if (inputButton) {
    done.disabled = true
    inputButton.addEventListener('change', () => {
      if (inputButton.value != "") {
        choose.style.backgroundColor = "#a8a8a8"
        choose.style.color = "white"
        done.disabled = false
      }
    });
  }
};

export { uploadButton };