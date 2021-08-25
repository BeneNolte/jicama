const dataInsightCard = () => {
  const defaultDisplay = document.querySelector(".default-display");
  const insightsDisplay = document.querySelector(".insights-display");

  const dataInsightsTitle = document.getElementById("data-insights-title")
  const locations = document.getElementById("locations");
  locations.addEventListener("click", () => {
    insightsDisplay.classList.toggle("d-none");
    defaultDisplay.classList.toggle("d-none");
    locations.classList.toggle("current")
    if (defaultDisplay.classList.contains("d-none")) {
      dataInsightsTitle.style.color = "white";
    } else {
      dataInsightsTitle.style.color = "black";
    }
  });
}

export { dataInsightCard };