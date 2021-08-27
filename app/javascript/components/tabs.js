const initTabs = () => {
  const allTab = document.getElementById("all-tab")
  const accessorsTab = document.getElementById("accessors-tab")
  const buyersTab = document.getElementById("buyers-tab")
  const restrictionsTab = document.getElementById("restrictions-tab")
  const deletionTab = document.getElementById("deletion-tab")

  if (document.location.pathname.includes("data_ownerships")) {

    allTab.addEventListener("click", () => {
      allTab.classList.add("active")
      accessorsTab.classList.remove("active")
      buyersTab.classList.remove("active")
      restrictionsTab.classList.remove("active")
      deletionTab.classList.remove("active")
    })

    accessorsTab.addEventListener("click", () => {
      allTab.classList.remove("active")
      accessorsTab.classList.add("active")
      buyersTab.classList.remove("active")
      restrictionsTab.classList.remove("active")
      deletionTab.classList.remove("active")
    })

    buyersTab.addEventListener("click", () => {
      allTab.classList.remove("active")
      accessorsTab.classList.remove("active")
      buyersTab.classList.add("active")
      restrictionsTab.classList.remove("active")
      deletionTab.classList.remove("active")
    })

    restrictionsTab.addEventListener("click", () => {
      allTab.classList.remove("active")
      accessorsTab.classList.remove("active")
      buyersTab.classList.remove("active")
      restrictionsTab.classList.add("active")
      deletionTab.classList.remove("active")
    })

    deletionTab.addEventListener("click", () => {
      allTab.classList.remove("active")
      accessorsTab.classList.remove("active")
      buyersTab.classList.remove("active")
      restrictionsTab.classList.remove("active")
      deletionTab.classList.add("active")
    })

  }
}

export { initTabs };