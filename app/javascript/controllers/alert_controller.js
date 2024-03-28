import { Controller } from 'stimulus'

export default class extends Controller {
  static values = {
    closeAfter: {
      type: Number,
      default: 25000
    },
    removeAfter: {
      type: Number,
      default: 11000
    },
  }

  initialize() {
    console.log('Initializing AlertController')
    this.hide()
  }

  connect() {
    setTimeout(() => {
      this.show()
    }, 50)
    console.log('Alert#connect')
    setTimeout(() => {
      this.close()
    }, this.closeAfterValue)
  }

  close() {
    this.hide()
    setTimeout(() => {
      this.element.remove()
    }, this.removeAfterValue)

  }

  show() {
    this.element.setAttribute(
      'style',
      "transition: 0.5s; transform:translate(0, -100px);",
    )
  }

  hide() {
    this.element.setAttribute(
      'style',
      "transition: 1s; transform:translate(0, 200px);",
    )
  }
}
