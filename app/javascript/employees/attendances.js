$(document).on("turbo:load", () => {
  $(".attendance-timepicker").timepicker({
    timeFormat: 'HH:mm',
    interval: 15,
    minTime: '00',
    maxTime: '23:45',
    startTime: '00:00',
    dynamic: false,
    dropdown: true,
    scrollbar: true,
    change: function () {
      this.trigger("change")
    }
  });

  let workHours = 0
  let breakHours = 0

  const $checkinDate = $("#attendance_checkin_date")
  const $checkinTime = $("#attendance_checkin_time")
  const $checkoutDate = $("#attendance_checkout_date")
  const $checkoutTime = $("#attendance_checkout_time")
  const $workHours = $("#attendance_work_hours")

  const updateWorkHours = () => {
    workHours = 0
    if ($checkinDate.val() && $checkinTime.val() && $checkoutDate.val() && $checkoutTime.val()) {
      const checkin = new Date(`${$checkinDate.val()} ${$checkinTime.val()}`.replace(/-/g, "/"))
      const checkout = new Date(`${$checkoutDate.val()} ${$checkoutTime.val()}`.replace(/-/g, "/"))
      workHours = (checkout - checkin) / 3600000 - breakHours
      $workHours.text(workHours.toString())
      $breakHours.text(breakHours.toString())
    } else {
      workHours = 0
    }

    $workHours.text(workHours.toString())
  }

  $checkinDate.on("changeDate", updateWorkHours)
  $checkinTime.on("change", updateWorkHours)
  $checkoutDate.on("changeDate", updateWorkHours)
  $checkoutTime.on("change", updateWorkHours)

  const $shift1CheckinDate = $("#attendance_shift_1_checkin_date")
  const $shift1CheckinTime = $("#attendance_shift_1_checkin_time")
  const $shift1CheckoutDate = $("#attendance_shift_1_checkout_date")
  const $shift1CheckoutTime = $("#attendance_shift_1_checkout_time")
  const $shift2CheckinDate = $("#attendance_shift_2_checkin_date")
  const $shift2CheckinTime = $("#attendance_shift_2_checkin_time")
  const $shift2CheckoutDate = $("#attendance_shift_2_checkout_date")
  const $shift2CheckoutTime = $("#attendance_shift_2_checkout_time")
  const $breakHours = $("#attendance_break_hours")

  const updateBreakHours = () => {
    breakHours = 0

    if ($shift1CheckinDate.val() && $shift1CheckinTime.val() && $shift1CheckoutDate.val() && $shift1CheckoutTime.val()) {
      const checkin =  new Date(`${$shift1CheckinDate.val()} ${$shift1CheckinTime.val()}`.replace(/-/g, "/"))
      const checkout =  new Date(`${$shift1CheckoutDate.val()} ${$shift1CheckoutTime.val()}`.replace(/-/g, "/"))
      breakHours += checkout - checkin
    }

    if ($shift2CheckinDate.val() && $shift2CheckinTime.val() && $shift2CheckoutDate.val() && $shift2CheckoutTime.val()) {
      const checkin =  new Date(`${$shift2CheckinDate.val()} ${$shift2CheckinTime.val()}`.replace(/-/g, "/"))
      const checkout =  new Date(`${$shift2CheckoutDate.val()} ${$shift2CheckoutTime.val()}`.replace(/-/g, "/"))
      breakHours += checkout - checkin
    }

    breakHours = breakHours / 3600000
    workHours -= breakHours
    $workHours.text(workHours.toString())
    $breakHours.text(breakHours.toString())
  }

  $shift1CheckinDate.on("changeDate", updateBreakHours)
  $shift1CheckinTime.on("change", updateBreakHours)
  $shift1CheckoutDate.on("changeDate", updateBreakHours)
  $shift1CheckoutTime.on("change", updateBreakHours)
  $shift2CheckinDate.on("changeDate", updateBreakHours)
  $shift2CheckinTime.on("change", updateBreakHours)
  $shift2CheckoutDate.on("changeDate", updateBreakHours)
  $shift2CheckoutTime.on("change", updateBreakHours)
})
