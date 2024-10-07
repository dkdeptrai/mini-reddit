import { Controller } from "@hotwired/stimulus";
import { useClickOutside, useWindowResize } from "stimulus-use";

// Connects to data-controller="navbar"
export default class extends Controller {
	static targets = ["content", "toggleButton", "overlay"];
	static classes = ["hidden", "blur"];

	connect() {
		this.close();
		useClickOutside(this);
		useWindowResize(this);
		this.addKeyboardListener();
	}

	disconnect() {
		this.removeKeyboardListener();
	}

	closeOnBigScreen({ width }) {
		if (width > 768) {
			this.close();
		}
	}

	clickOutside(event) {
		if (!this.element.contains(event.target)) {
			this.close();
		}
	}

	closeWithKeyboard(event) {
		if (event.key === "Escape") {
			this.close();
		}
	}

	toggle() {
		this.contentTarget.classList.contains(this.hiddenClass) ? this.open() : this.close();
	}

	open() {
		this.contentTarget.classList.remove(this.hiddenClass);
		this.overlayTarget.classList.remove(this.hiddenClass);
		this.toggleButtonTarget.setAttribute("aria-expanded", "true");
		document.body.classList.add("overflow-hidden");
	}

	close() {
		this.contentTarget.classList.add(this.hiddenClass);
		this.overlayTarget.classList.add(this.hiddenClass);
		this.toggleButtonTarget.setAttribute("aria-expanded", "false");
		document.body.classList.remove("overflow-hidden");
	}

	addKeyboardListener() {
		this.boundKeyHandler = this.closeWithKeyboard.bind(this);
		document.addEventListener("keydown", this.boundKeyHandler);
	}

	removeKeyboardListener() {
		document.removeEventListener("keydown", this.boundKeyHandler);
	}
}
