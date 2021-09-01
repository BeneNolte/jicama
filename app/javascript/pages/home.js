const logoHome = () => {
  const bigLogo = document.querySelector(".logo-sizing")
  const smallLogo = document.querySelector(".logo-navbar")

  if (bigLogo) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= 0 && window.scrollY < (banner.offsetHeight - navbar.offsetHeight)) {
        navbar.classList.remove('navbar-lewagon-home-transparent');
      } else if (window.scrollY >= (banner.offsetHeight - navbar.offsetHeight) && window.scrollY < banner.offsetHeight) {
        navbar.classList.add('navbar-lewagon-home-transparent');
        navbar.classList.remove('navbar-lewagon-home-white');
      } else if (window.scrollY >= banner.offsetHeight && window.scrollY < (process.offsetTop - navbar.offsetHeight)) {
        navbar.classList.remove('navbar-lewagon-home-transparent');
        navbar.classList.add('navbar-lewagon-home-white');
      } else if (window.scrollY >= (process.offsetTop - navbar.offsetHeight) && window.scrollY < process.offsetTop) {
        navbar.classList.remove('navbar-lewagon-home-white');
        navbar.classList.add('navbar-lewagon-home-transparent');
      } else if (window.scrollY >= process.offsetTop && window.scrollY < (statistics.offsetTop - navbar.offsetHeight)) {
        navbar.classList.remove('navbar-lewagon-home-transparent');
      } else if (window.scrollY >= (statistics.offsetTop - navbar.offsetHeight) && window.scrollY < statistics.offsetTop) {
        navbar.classList.add('navbar-lewagon-home-transparent');
        navbar.classList.remove('navbar-lewagon-home-white');
      } else if (window.scrollY >= (statistics.offsetTop) && window.scrollY < footer.offsetTop) {
        navbar.classList.remove('navbar-lewagon-home-transparent');
        navbar.classList.add('navbar-lewagon-home-white');
      }
    })
  }
}
export { logoHome };