const initBottombar = () => {
  const datasourceButton = document.getElementById("datasource-button")
  const dashboardButton = document.getElementById("dashboard-button")
  const datacontrolButton = document.getElementById("datacontrol-button")

  if (document.location.pathname.includes("datasources") && !document.location.pathname.includes("data_ownerships") && !document.location.pathname.includes("tuto") ) {
    setTimeout(() => { datasourceButton.style.opacity = 1; }, 100);
  }

  if (document.location.pathname === "/dashboard") {
    setTimeout(() => { dashboardButton.style.opacity = 1; }, 100);
  }

  if (document.location.pathname.includes("data_ownerships")) {
    setTimeout(() => { datacontrolButton.style.opacity = 1; }, 100);
  }
}

export { initBottombar };