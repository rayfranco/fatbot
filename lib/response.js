class Response {
  constructor () {
    this.nick = '' // The emmiter
    this.to = '' // The receiver (if apply)
    this.channel = '' // The channel
    this.server = '' // The server
    this.text = '' // The text sent

    this.client = {}
  }

  reply (txt) {}

  whois () {}

  kick () {}

  ban () {}
}
