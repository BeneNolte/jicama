const logoHome = () => {
  const bigLogo = document.querySelector(".logo-sizing")
  const smallLogo = document.querySelector(".logo-navbar")
  
  const homeButtons = document.querySelectorAll(".main-home-button")


  if (bigLogo) {
    window.addEventListener('scroll', () => {

      bigLogo.style.opacity = 1/((window.scrollY + 100)/100);

      smallLogo.style.opacity = 1 - 1/((window.scrollY + 50)/50);

    })

    let count = 30;

    homeButtons.forEach((homeButton) => {

      homeButton.addEventListener("click", (event) => {
        event.preventDefault();
        setInterval(() => {
          var $badge = $('#nhb_01');
          count += 10;
          homeButton.style.boxShadow = `0px 0px ${count}px ${3 + count / 10}px white`; 
          $badge.text(count.toFixed(2));
        }, 10);
  
        setTimeout(() => { window.location.href = '/dashboard' }, 500);
      })
    })
    
    
  }

}
export { logoHome };

