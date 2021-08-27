const initBottombar = () => {
  const datasourceButton = document.getElementById("datasource-button")
  const dashboardButton = document.getElementById("dashboard-button")
  const datacontrolButton = document.getElementById("datacontrol-button")

  if (document.location.pathname.includes("datasources") && !document.location.pathname.includes("data_ownerships")  ) {
    console.log("hello")
    datasourceButton.style.opacity = 1;
  }

  if (document.location.pathname === "/dashboard") {
    dashboardButton.style.opacity = 1;
  }

  if (document.location.pathname.includes("data_ownerships")) {
    datacontrolButton.style.opacity = 1;
  }
}

export { initBottombar };