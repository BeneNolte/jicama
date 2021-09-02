const logoHome = () => {
  const bigLogo = document.querySelector(".logo-sizing")
  const smallLogo = document.querySelector(".logo-navbar")
  
  const homeButton = document.getElementById("main-home-button")


  if (bigLogo) {
    window.addEventListener('scroll', () => {

      bigLogo.style.opacity = 1/((window.scrollY + 100)/100);

      smallLogo.style.opacity = 1 - 1/((window.scrollY + 50)/50);

    })
    
    let secs = 10 * 60;
    let count = 0;
    setInterval(() => {
      var $badge = $('#nhb_01');
      count += 500;
      $badge.text(count.toFixed(2));
    }, secs);
    console.log(count)
    
    homeButton.addEventListener("click", (event) => {

      event.preventDefault();
      setTimeout(() => {}, 1000);
      homeButton.style.boxShadow = `0px 0px 32px ${count}px white`; 
    })
    
  }

}
export { logoHome };
