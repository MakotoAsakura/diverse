import "trix"
import "@rails/actiontext"

window.addEventListener("trix-file-accept", function(event) {
  const acceptedTypes = ["image/jpeg", "image/png"]
  if (!acceptedTypes.includes(event.file.type)) {
    event.preventDefault()
    alert("PNGまたはJPGのファイルをアップロードしてください。")
    return
  }

  const maxFileSize = 10 * 1024 * 1024 // 10MB
  if (event.file.size > maxFileSize) {
    event.preventDefault()
    alert("10MB以下のファイルをアップロードしてください。")
  }
})


$("#newTaxWithholding, .editTaxWithholding").on("hidden.bs.modal", function () {
  location.reload()
})
