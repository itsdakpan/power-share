import { Controller } from "@hotwired/stimulus"

// Removes the element it is attached to, e.g. a flash message.
export default class extends Controller {
  close() {
    this.element.remove()
  }
}
