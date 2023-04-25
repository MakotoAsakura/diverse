$(document).on("turbo:load", () => {
  const screenVal = $("#screen")

  if (screenVal.val() === "chat") {
    const firebaseConfig = {
      apiKey: "AIzaSyBcRb-khOiSFD1wjg0VDLifXvQuqXfYJcg",
      authDomain: "diverse-1b8db.firebaseapp.com",
      projectId: "diverse-1b8db",
      storageBucket: "diverse-1b8db.appspot.com",
      messagingSenderId: "891402669158",
      appId: "1:891402669158:web:a2b3bedc6f83259298f1a7"
    };

    // firebase
    if (!firebase.apps.length) {
      firebase.initializeApp(firebaseConfig)
    }else {
      firebase.app()
    }

    const db = firebase.firestore();
    const room_code = $("#room_id").val()
    const firebaseToken = Cookies.get("firebase_token")

    showLoading()
    firebase.auth().signInWithCustomToken(firebaseToken)
      .then((userCredential) => {
        hideLoading()
        showMessage()
      })
      .catch((error) => {
        console.log(error.message)
      });

    $('#sendMsgBtn').on('click', function (e) {
      e.preventDefault();

      sendMessage()
      scrollToBottom()
    })

    function sendMessage() {
      const message = $("#content_chat").val().replace(/\r\n|\r|\n/g,"<br />")

      if (!message || message.trim().length === 0) return
      const created_at = Date.now()
      const sender_id = $("#sender").val()
      const sender_name = $("#sender_name").val()
      db.collection(`messages`).doc(`${room_code}`).collection("message").add({
        sender_id,
        message,
        room_code,
        sender_name,
        created_at
      })
        .then((docRef) => {
          $.ajax({
              type: "put",
              url: `/chats/${room_code}`,
              data: {room: {last_message: message, last_sender_id: sender_id}},
              dataType: "json",
              success: function () {
                console.log("success")
              }
            }
          )
        })
        .catch((error) => {
          console.error("Error adding document: ", error);
        })

      $("#content_chat").val("")
    }

    function addMessage(msg) {
      const senderName = $("#sender_name").val()
      const receiverName = $("#receiver_name").val()
      const receiverMsg =
        `<div class="row g-0">
              <div class="col-md-8 col-xxl-6">
                <div class="chat-item">
                  <div class="chat-name">${receiverName}</div>
                  <div class="chat-body">
                    <div class="row g-1 align-items-end">
                      <div class="col-8 col-md-12">
                        <div class="chat-text">${msg.message}</div>
                      </div>
                      <div class="col-4 col-md-12">
                        <div class="chat-meta text-md-end">
                          <div class="chat-ago d-inline-block text-center">
                            <span class="chat-ago-date">${convertDate(msg.created_at)}</span>
                            <span class="chat-ago-time d-block d-md-inline">${convertTime(msg.created_at)}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>`
      const senderMsg = `
        <div class="row g-0 flex-row-reverse">
          <div class="col-md-8 col-xxl-6">
            <div class="chat-item">
              <div class="chat-name text-md-end">${senderName}</div>
              <div class="chat-body">
                <div class="row g-1 align-items-end">
                  <div class="col-8 col-md-12">
                    <div class="chat-text">${msg.message}</div>
                  </div>
                  <div class="col-4 col-md-12">
                    <div class="chat-meta text-md-end">
                      <div class="chat-ago d-inline-block text-center">
                        <span class="chat-ago-date">${convertDate(msg.created_at)}</span>
                        <span class="chat-ago-time d-block d-md-inline">${convertTime(msg.created_at)}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>`

      const sender_id = $("#sender").val()

      const message = sender_id === msg.sender_id ? senderMsg : receiverMsg
      // append the message on the page
      document.getElementById("chat-content").innerHTML += message;
    }

    function showMessage() {
      if(typeof(window.snapshotMsg) ==='function') {
        window.snapshotMsg()
      }
      window.snapshotMsg = db.collection(`messages`).doc(`${room_code}`).collection("message").orderBy("created_at", "asc").onSnapshot((snapshot) => {
        snapshot.docChanges().forEach((change) => {
          addMessage(change.doc.data())
        })
        markRead()
        scrollToBottom()
      });
    }

    function markRead() {
      if($("#role").val() == "candidate"){
        $.ajax({
            type: "put",
            url: `/chats/${room_code}/mark_read`,
            dataType: "json",
            success: function () {
              console.log("success")
            }
          }
        )
      }
      if($("#role").val() == "medical"){
        $.ajax({
            type: "put",
            url: `/medical/chats/${room_code}/mark_read`,
            dataType: "json",
            success: function () {
              console.log("success")
            }
          }
        )
      }
    }
  }

  function convertDate(timestamp) {
    const date = new Date(timestamp)
    const month = date.getMonth() + 1
    return `${date.getFullYear()}/${month < 10 ? "0" + month : month}/${date.getDate() < 10 ? "0" + date.getDate() : date.getDate()}`
  }

  function convertTime(timestamp) {
    const date = new Date(timestamp)

    return `${date.getHours()}:${date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes()}:${date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds()}`
  }

  function scrollToBottom(){
    setTimeout(() => {
      window.scrollTo(0, document.body.scrollHeight);
    }, 0);
  }
})
