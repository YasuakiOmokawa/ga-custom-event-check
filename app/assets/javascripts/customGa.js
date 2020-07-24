$(document).on("turbolinks:load", function () {
  console.log("Initialize Custom GA script");

  $("#create-project").on("click", function () {
    console.log("Create Project!");
    ga("send", {
      hitType: "event",
      eventCategory: "Projects",
      eventAction: "create",
      eventLabel: "",
    });
  });
});
