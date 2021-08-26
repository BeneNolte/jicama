const dataInsightCard = () => {
  if (document.querySelector(".default-display")) {

    const defaultDisplay = document.querySelector(".default-display");
    const insightsDisplay = document.querySelector(".insights-display");
    const insightsTitle = document.getElementById("data-insights-title")
  
    const insights = document.querySelectorAll(".insights")
  
    const locations = document.getElementById("locations");
    const interests = document.getElementById("interests");
    const ads = document.getElementById("ads");
    const youtubeChannels = document.getElementById("youtube-channels");
  
    const locationInsights = document.getElementById("locations-insights");
    const interestInsights = document.getElementById("interests-insights");
    const adInsights = document.getElementById("ads-insights");
    const ytInsights = document.getElementById("yt-insights");
  
    const insightsTitleLogic = () => {
      if (defaultDisplay.classList.contains("opacity")) {
        insightsTitle.style.color = "white";
      } else {
        insightsTitle.style.color = "black";
      }
    }
  
    const deleteInsightsLogic = () => {
      insights.forEach((insight) => {
        insight.classList.add("opacity")
      });
    }
  
    locations.addEventListener("click", () => {
      deleteInsightsLogic();
      locationInsights.classList.remove("opacity")
      locationInsights.classList.remove("d-none")
      locations.classList.toggle("current");
      if (interests.classList.contains("current") || ads.classList.contains("current") || youtubeChannels.classList.contains("current")) {   
        interests.classList.remove("current");
        ads.classList.remove("current");
        youtubeChannels.classList.remove("current");
      } else {
        insightsDisplay.classList.toggle("opacity");
        defaultDisplay.classList.toggle("opacity");
      }
      insightsTitleLogic();
    });
  
    interests.addEventListener("click", () => {
      deleteInsightsLogic();
      interestInsights.classList.remove("opacity")
      interestInsights.classList.remove("d-none")
      interests.classList.toggle("current");
      if (locations.classList.contains("current") || ads.classList.contains("current") || youtubeChannels.classList.contains("current")) {   
        locations.classList.remove("current");
        ads.classList.remove("current");
        youtubeChannels.classList.remove("current");
      } else {
        insightsDisplay.classList.toggle("opacity");
        defaultDisplay.classList.toggle("opacity");
      }
      insightsTitleLogic();
    });
  
    ads.addEventListener("click", () => {
      deleteInsightsLogic();
      adInsights.classList.remove("opacity")
      adInsights.classList.remove("d-none")
      ads.classList.toggle("current");
      if (interests.classList.contains("current") || locations.classList.contains("current") || youtubeChannels.classList.contains("current")) {   
        interests.classList.remove("current");
        locations.classList.remove("current");
        youtubeChannels.classList.remove("current");
      } else {
        insightsDisplay.classList.toggle("opacity");
        defaultDisplay.classList.toggle("opacity");
      }
      insightsTitleLogic();
    });
  
    youtubeChannels.addEventListener("click", () => {
      deleteInsightsLogic();
      ytInsights.classList.remove("opacity")
      ytInsights.classList.remove("d-none")
      youtubeChannels.classList.toggle("current");
      if (interests.classList.contains("current") || ads.classList.contains("current") || locations.classList.contains("current")) {   
        interests.classList.remove("current");
        ads.classList.remove("current");
        locations.classList.remove("current");
      } else {
        insightsDisplay.classList.toggle("opacity");
        defaultDisplay.classList.toggle("opacity");
      }
      insightsTitleLogic();
    });

  }

}

export { dataInsightCard };