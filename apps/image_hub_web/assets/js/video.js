import Player from "./player"
import {Presence} from "phoenix"

let Video = {
  init(socket, element) {
    if (!element) { return }

    let videoId = element.getAttribute("data-id")
    let playerId = element.getAttribute("data-player-id")
    socket.connect()

    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket)
    })
  },

  onReady(videoId, socket) {
    let msgContainer = document.getElementById("msg-container")
    let msgInput = document.getElementById("msg-input")
    let msgPostBtn = document.getElementById("msg-submit")
    let userList = document.getElementById("user-list")
    let lastSeenId = 0
    let videoChannel = socket.channel(`videos:${videoId}`, () => {
      return {last_seen_id: lastSeenId}
    })
    let presence = new Presence(videoChannel)
    presence.onSync(() => {
      userList.innerHTML = presence.list((id, {metas: [first, ...rest]}) => {
        let count = rest.length + 1
        return `<li>${id}: (${count})</li>`
      }).join(" ")
    })

    msgContainer.addEventListener("click", e => {
      e.preventDefault()
      let seconds = e.target.getAttribute("data-seek") || e.target.parentNode.getAttribute("data-seek")
      if(!seconds) { return }
      Player.seekTo(seconds)
    })

    videoChannel.join()
      .receive("ok", resp => {
        let ids = resp.annotations.map(ann => ann.id)
        if (ids.length > 0) {
          lastSeenId = Math.max(...ids)
        }

        this.scheduleMessages(msgContainer, resp.annotations)
        //annotations.forEach(annotation => this.renderAnnotation(msgContainer, annotation))
      })
      .receive("error", resp => { console.log("Unable to join", resp) })

    videoChannel.on("ping", ({count}) => { console.log("PING", count)})

    msgPostBtn.addEventListener("click", function(){
      let payload = {body: msgInput.value, at: Player.getCurrentTime()}
      videoChannel.push("new_annotation", payload).receive("error", e => console.log(e))
      msgInput.value = ""
    })

    videoChannel.on("new_annotation", (resp) => {
      lastSeenId = resp.id
      this.renderAnnotation(msgContainer, resp)
    })
  },

  scheduleMessages(msgContainer, annotations) {
    clearTimeout(this.scheduleTimer)
    this.scheduleTimer = setTimeout(() => {
      let ctime = Player.getCurrentTime()
      let remaining = this.renderAtTime(annotations, ctime, msgContainer)
      this.scheduleMessages(msgContainer, remaining)
    }, 1000)
  },

  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter(ann => {
      if (ann.at > seconds) { return true }
      else {
        this.renderAnnotation(msgContainer, ann)
        return false
      }
    })
  },

  formatTimeAt(at) {
    let date = new Date(null)
    date.setSeconds(at/1000)
    return date.toIOSString().substr(14,5)
  },

  esc(str) {
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    let template = document.createElement("div")
    template.innerHTML = `
    <a href="#" data-seek="${this.esc(at)}">
      <b>${this.esc(user.username)}</b>: ${this.esc(body)}
    </a>
    `
    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  }
}

export default Video
