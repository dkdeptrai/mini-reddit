import {Controller} from "@hotwired/stimulus";

// Connects to data-controller="comment-reply"
export default class extends Controller {
	static targets = ["replyButton", "replyForm"];

	connect() {
		this.replyFormTarget.style.display("none");
	}

	toggleReplyForm() {
		if (this.replyFormTarget.style.display === "none") {
			this.showReplyForm();
		} else {
			this.hideReplyForm();
		}
	}

	showReplyForm() {
		this.replyFormTarget.style.display = "block";
	}

	hideReplyForm() {
		this.replyFormTarget.style.display = "none";
	}

	submitForm(event) {
		if (event.detail.success) {
			this.hideReplyForm();
		}
	}
}
