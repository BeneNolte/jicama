const initNavbar = () => {
  const navbar = document.querySelector(".navbar");
  if (document.location.pathname === "/") {
    navbar.classList.add("d-none")
  }
}

export { initNavbar };