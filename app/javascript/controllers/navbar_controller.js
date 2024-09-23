import {Controller} from "@hotwired/stimulus";
import {useClickOutside} from "stimulus-use";

// Connects to data-controller="navbar"
export default class extends Controller {
	static targets = ["content"];

	connect() {

		this.close();
		useClickOutside(this, { element: this.contentTarget, events: ["click"], onlyVisible: true });
	}

	closeOnBigScreen() {
		if (window.innerWidth > 768) {
			this.close();
		}
	}

	clickOutside(event) {
		this.close();
	}

	closeWithKeyboard(event) {
		if (event.key === "Escape") {
			this.close();
		}
	}

	toggle() {
		if (this.contentTarget.classList.contains("hidden")) {
			this.open();
		} else {
			this.close();
		}
	}


	open() {
		this.contentTarget.classList.remove("hidden");
		document.querySelector("main")?.classList.add("blur");
	}

	close() {
		this.contentTarget.classList.add("hidden");
		document.querySelector("main")?.classList.remove("blur");
	}
}
