const $ = window.jQuery
const bootstrap = window.bootstrap

$(document).ready(() => {
  $(".sidebar-toggle").click(() => {
    $(".admin-sidebar").toggleClass("show")
  })

  $(document).click((e) => {
    if (!$(e.target).closest(".admin-sidebar, .sidebar-toggle").length) {
      $(".admin-sidebar").removeClass("show")
    }
  })

  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map((tooltipTriggerEl) => new bootstrap.Tooltip(tooltipTriggerEl))
})
