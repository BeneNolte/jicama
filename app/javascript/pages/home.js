const logoHome = () => {
  const bigLogo = document.querySelector(".logo-sizing")
  const smallLogo = document.querySelector(".logo-navbar")

  if (bigLogo) {
    window.addEventListener('scroll', () => {

      bigLogo.style.opacity = 1/((window.scrollY + 100)/100);

      smallLogo.style.opacity = 1 - 1/((window.scrollY + 50)/50);

    })
  }
}
export { logoHome };
