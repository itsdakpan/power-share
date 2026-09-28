import { Controller } from "@hotwired/stimulus"

// Shows the live booking total as the dates change.
export default class extends Controller {
  static targets = ["start", "end", "days", "amount"]
  static values = { price: Number }

  connect() {
    this.update()
  }

  update() {
    const start = new Date(this.startTarget.value)
    const end = new Date(this.endTarget.value)
    const days = Math.round((end - start) / 86400000) + 1

    if (Number.isNaN(days) || days < 1) {
      this.daysTarget.textContent = "Pick your dates"
      this.amountTarget.textContent = "£0"
      return
    }

    this.daysTarget.textContent = `${days} ${days === 1 ? "day" : "days"}`
    const total = days * this.priceValue
    this.amountTarget.textContent = `£${Number.isInteger(total) ? total : total.toFixed(2)}`
  }
}
