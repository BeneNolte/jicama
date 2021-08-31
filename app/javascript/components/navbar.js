// app/javascript/components/navbar.js
const initUpdateNavbarOnScroll = () => {
  const navbar = document.querySelector('.navbar-lewagon-home');
  const banner = document.querySelector('.banner');
  const process = document.querySelector('.process-explanation-home');
  const statistics = document.querySelector('.statistics-home');
  const footer = document.querySelector('.footer');

  if (navbar) {
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
      } else if (window.scrollY >= (statistics.offsetTop) && window.scrollY < footer.offsetTop) {
        navbar.classList.remove('navbar-lewagon-home-transparent');
        navbar.classList.add('navbar-lewagon-home-white');
      }



      // console.log("window.scrollY", window.scrollY)
      // console.log("window.innerHeight", window.innerHeight)
      // if (window.scrollY >= 0 && window.scrollY + 158 >= window.innerHeight) {
      //   navbar.classList.add('navbar-lewagon-home-transparent');
      // }
      // else {
      //   navbar.classList.remove('navbar-lewagon-home-transparent');
      // }
      // if (window.scrollY >= banner.offsetHeight) {
      //   navbar.classList.remove('navbar-lewagon-home-transparent');
      //   navbar.classList.add('navbar-lewagon-home-white');
      // } else {
      //   navbar.classList.remove('navbar-lewagon-home-white');
      // }
      // if (window.scrollY >= process.offsetTop) {
      //   console.log("Hello")
      //   console.log(process.offsetHeight)
      //   navbar.classList.add('navbar-lewagon-home-transparent');
      //   navbar.classList.remove('navbar-lewagon-home-white');
      // } else {
      //   navbar.classList.add('navbar-lewagon-home-white');
      // }
    });
  }
}

export { initUpdateNavbarOnScroll };
