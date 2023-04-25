// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"
import "jquery_ujs"
import "vanillajs-datepicker"
import DatepickerLang from "vanillajs-datepicker-i18n-ja"
import "jquery-timepicker"
import "js-cookie"
import "employees/loading"
import "employees/attendances"
import "employees/chat"
import "employees/profile"
import "medicals/attendance"
import "medicals/tax_withholding"
import "@nathanvda/cocoon"
import "medicals/lightbox"

Object.assign(Datepicker.locales, DatepickerLang)

$(document).on("turbo:load", () => {
  $.TimePicker._instance = undefined // fix: timepicker - rails turbo

  $.fn.inputFilter = function (callback) {
    return this.on("input keydown keyup mousedown mouseup select contextmenu drop focusout", function (e) {
      if (callback(this.value)) {
        this.oldValue = this.value;
        this.oldSelectionStart = this.selectionStart;
        this.oldSelectionEnd = this.selectionEnd;
      } else if (this.hasOwnProperty("oldValue")) {
        this.value = this.oldValue;
        this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
      } else {
        this.value = "";
      }
    });
  };

  $(".numberonly").inputFilter(function (value) {
    return /^\d*$/.test(value);
  });

  $(".numberonly-phone-number-medical").inputFilter(function (value) {
    return /^[\d|-]*$/.test(value);
  });

  if ($(".zipcode-first, .zipcode-last").length) {
    $(".zipcode-first, .zipcode-last").focusout((function () {
      let zipcode = $(this).parents(".zipcode");
      let zipcodeValue = zipcode.find(".zipcode-first").val() + zipcode.find(".zipcode-last").val();
      let location = zipcode.closest(".wrap-info").find(".location textarea")
      if (zipcodeValue.length === 7 && (parseFloat(zipcodeValue) === parseInt(zipcodeValue)) && !isNaN(zipcodeValue)) {
        $.ajax({
          url: "/zip_codes/search?code=" + zipcodeValue,
          cache: false,
          dataType: "json",
          type: "GET",
          success: function (data) {
            if (data.result) {
              location.val(data.result.prefecture + data.result.city + data.result.town)
            } else {
              location.val("")
            }
          },
        });
      }
    }))
  }

  const screenVal = $("#screen")
  if (screenVal.val() === "new_medical" || screenVal.val() === "new_candidate" || screenVal.val() === "confirm_delete_account") {
    $(".btn-submit").prop('disabled', true)

    $("#policy_cbx").change(function () {
      if ($(this).is(':checked')) {
        $(".btn-submit").prop('disabled', false)
      } else {
        $(".btn-submit").prop('disabled', true)
      }
    })
  }

  $("#post_code_search").on("click", function () {

    const zipCode = $("#item_zipcode").val()

    if (zipCode.length === 7 && (parseFloat(zipCode) === parseInt(zipCode)) && !isNaN(zipCode)) {
      $.ajax({
        url: "/zip_codes/search?code=" + zipCode,
        cache: false,
        dataType: "json",
        type: "GET",
        success: function (data) {
          if (data.result) {
            $("#item_prefecture").val(data.result.prefecture)
            $("#item_city").val(data.result.city + data.result.town)
          } else {
            $("#item_prefecture").val("")
            $("#item_city").val("")
            location.val("")
          }
        },
      });
    }
  });

  const datepickerDefaults = document.getElementsByClassName("datepicker-default")

  Array.from(datepickerDefaults).forEach((elem) => {
    let maxDate = elem.getAttribute("maxDate")
    let minDate = elem.getAttribute("minDate")
    let pickLevel = elem.getAttribute("pickLevel")
    if (pickLevel === null) pickLevel = "0";
    let format = "yyyy-mm-dd"
    if (pickLevel === "1") {
      format = "yyyy-mm"
    } else if (pickLevel === "2") {
      format = "yyyy"
    }

    new Datepicker(elem, {
      language: "ja", format: format, autohide: true, maxDate: maxDate, minDate: minDate, pickLevel: pickLevel
    });
  })

  $(".input-group span").on("click", function () {
    $(this).parent().find("input").focus()
  })

  $(".calendar-icon").on("click", function () {
    $(this).parents(".row").eq(0).find("input").focus()
  })

  $('input.timepicker').timepicker({
    timeFormat: 'HH:mm',
    interval: 15,
    minTime: '00',
    maxTime: '23:45',
    startTime: '00:00',
    dynamic: false,
    dropdown: true,
    scrollbar: true
  });

  function getFileNumber(element) {
    const idBtn = $(element).prop('id')

    return idBtn.charAt(idBtn.length - 1)
  }

  $(".btn-upload-file").click(function () {
    const fileNumber = getFileNumber(this)

    $(`#select_file_${fileNumber}`).trigger("click")
  })

  $(".cv-file").change(function () {
    let fileName = $(this).val();
    const fileNumber = getFileNumber(this)

    $(`#file_name_${fileNumber}`).val(fileName.match(/[^\\/]*$/)[0]);
    if (screenVal.val() === "edit_profile") {
      const currentDestroyAttachment = $(`#destroy_attachment_${fileNumber}`)
      if ($(currentDestroyAttachment).is(':checked')) {
        $(currentDestroyAttachment).prop("checked", false)
      }
    }
  });

  $(".btn-delete-file").click(function () {
    const fileNumber = getFileNumber(this)

    $(`#select_file_${fileNumber}`).val(null)
    $(`#file_name_${fileNumber}`).val("");
    $(`#description_attachments_${fileNumber}`).val("")

    if (screenVal.val() === "edit_profile") {
      $(`#destroy_attachment_${fileNumber}`).prop("checked", true);
    }
  })

  $(".cv-field").each((index, element) => {
    if ($(element).hasClass("danger")) {
      $(element).closest("td").addClass("td-danger")
    }
  })

  if (screenVal.val() === "create_profile" || screenVal.val() === "edit_profile") {
    const otherCertificates = $("#cbx_certificate_9")

    function showOtherCertificates() {
      if ($(otherCertificates).is(':checked')) {
        $("#other_certificates").prop('disabled', false)
      } else {
        $("#other_certificates").prop('disabled', true)
      }
    }

    showOtherCertificates()

    $(otherCertificates).change(function () {
      showOtherCertificates()
    })
  }

  let checkBoxConfirm = $("#check_box_confirm");
  if (checkBoxConfirm) {
    checkBoxConfirm.change(() => {
      $(".send").find("button").prop("disabled", !checkBoxConfirm.is(":checked"));
    });
  }

  let listCheckActionCommit = $("input.check-action-commit")
  listCheckActionCommit.each(function () {
    console.log($(this).attr('class'))
    $(this).change(() => {
      $("button.action-commit").prop("disabled", !checkConditionCommitJob(listCheckActionCommit))
      if (checkConditionCommitJob(listCheckActionCommit)) {
        $("button.action-commit").removeClass("btn-grey");
        $("button.action-commit").addClass("btn-primary");
      } else {
        $("button.action-commit").addClass("btn-grey");
        $("button.action-commit").removeClass("btn-primary");
      }
    });
  })

  function checkConditionCommitJob(listCheckActionCommit) {
    let isCheckAll = true;

    listCheckActionCommit.each(function () {
      if (!$(this).is(":checked")) {
        isCheckAll = false
      }
    });

    return isCheckAll;
  }

  const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
  popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  })

  const dt = new DataTransfer();

  $("#attachment").on('change', function (e) {
    const fileSize = this.files[0].size;
    const maxFileSize = 10 * 1024 * 1024 // 10MB
    if (fileSize > maxFileSize) {
      alert("10MB以下のファイルをアップロードしてください。")
      return false;
    }

    for (var i = 0; i < this.files.length; i++) {
      let fileBloc = $('<div/>', {class: 'file-block row mb-2'}),
          fileName = $('<div/>', {class: 'filename col-3', text: this.files.item(i).name});
      fileBloc.append(fileName).append('<span class="file-delete col-auto"><button class="btn button save btn-submit w-100">削除</button></span>');

      let fileInputBlock = $('<div/>', {class: 'file-input-block ms-3'});
      $("#filesList > #files-names").append(fileInputBlock.append(fileBloc));
    }
    for (let file of this.files) {
      dt.items.add(file);
    }
    this.files = dt.files;

    $('span.file-delete').click(function () {
      let name = $(this).prev('div.filename').text();
      $(this).parent().remove();
      for (let i = 0; i < dt.items.length; i++) {
        if (name === dt.items[i].getAsFile().name) {
          dt.items.remove(i);
        }
      }
      document.getElementById('attachment').files = dt.files;
    });
  });

  if ($('span.file-delete-ids').length) {
    $('span.file-delete-ids').click(function (e) {
      e.preventDefault()
      let fileInputBlock = $(this).parents(".file-input-block")
      fileInputBlock.find("input").attr("name", "file_remove_ids[]")
      fileInputBlock.hide();
    });
  }

  $("textarea.auto-height").on( "keyup", function (e){
    $(this).css("height", "auto" ); // you can have this here or declared in CSS instead
    $(this).height( this.scrollHeight );
  }).keyup();

  if ($(".action-show-error").length) {
    $(".action-show-error").click(function() {
        $(".error-message").removeClass("d-none");
    });
  }

  $('#item_reason').on('keyup', function () {
    if ($('#item_reason').val().length === 0)
      $('.btn-reject button').attr('disabled', 'disabled');
    else
      $('.btn-reject button').attr('disabled', false);
  });
});
