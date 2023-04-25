$(document).on("turbo:load", () => {
    $(".btn-accept-attendance, .btn-reject-attendance").click(function(event){
        event.preventDefault()
        const idBtn = this.id
        const idSplit = idBtn.split("-")
        const idAttendance = idSplit[idSplit.length - 1]
        $("#form-accept-attendance").attr('action', '/medical/attendances/' + idAttendance)
        $.ajax({
            url: "/medical/attendances/" + idAttendance,
            dataType: "json",
            type: "GET",
            success: function (data) {
                if (data) {
                    $("#attendance_day").text(`${data.attendance_date} (月)`)
                    $("#start_work_time").text(`${data.checkin_time}`)
                    $("#end_work_time").text(`${data.checkout_time}`)
                    $("#start_break_time_1").text(data.start_break_time1 ? `${data.start_break_time1}` : "-")
                    $("#end_break_time_1").text(data.end_break_time1 ? `${data.end_break_time1}` : "-")
                    $("#start_break_time_2").text(data.start_break_time2 ? `${data.start_break_time2}` : "-")
                    $("#end_break_time_2").text(data.end_break_time2 ? `${data.end_break_time2}` : "-")
                    $("#attendance_note").text(data.note)
                    $("#reject_note").text(data.reject_note ? `${data.reject_note}` : "")

                    $("#btn-open-modal-accept").click()
                } else {
                }
            },
        });
    })
    let rejectModal;
    $(".btn-reject-attendance").click(function(event){
        $("#status_field").val("rejected")
        $(".reject_note").show()
        $("#text-confirm-attendance").text("出退勤を差し戻しますか？")
        rejectModal = true
    })

    $(".btn-accept-attendance").click(function(event){
        $("#status_field").val("approved")
        $(".reject_note").hide()
        $("#text-confirm-attendance").text("出退勤を承認しますか？")
        rejectModal = false
    })

    $(".btn-submit-modal").click(function(e){
        if(rejectModal) {
            e.preventDefault()
            if($("#reject_note").val().trim().length > 0){
                $("#form-accept-attendance").submit()
            } else {
                if(!$("#reject_note").hasClass("danger")) {
                    $("#reject_note").addClass("danger")
                    $("#reject_note").after('<div class="i-helper danger"> 差し戻し理由を入力してください。</div>')
                }
            }
        }
    })
})
