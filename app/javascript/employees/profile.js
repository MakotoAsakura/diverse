$(document).on("turbo:load", () => {
  const screenVal = $("#screen")

  if (screenVal.val() === "edit_profile") {
    $("#insert-profile-btn").click(function (e){
      if($(".nested-fields").length >= 20) return false
    })

    $(".delete-profile-btn").click(function () {
      if($(".nested-fields").length <= 1) return false
    })
  }
})
