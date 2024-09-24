import {Controller} from "@hotwired/stimulus";

// Connects to data-controller="theme"
export default class extends Controller {
	static targets = ["toggle"];

	// define some variables
	darkIcon = `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
</svg>
`
	lightIcon = `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
</svg>
`
	connect() {

		const storedTheme = localStorage.getItem("theme");
		if (storedTheme) {
			this.isDarkMode = storedTheme === "dark";
		} else {
			fetch("/load_theme").then(response => response.json()).then(data => {
				const theme = data.theme;
				localStorage.setItem("theme", theme);
				this.isDarkMode = theme === "dark";
			});
		}
		this.initializeLayout();
	}

	initializeLayout() {
		console.log("init", this.isDarkMode)
		if (this.isDarkMode) {
			this.toggleTarget.innerHTML = this.darkIcon;
		} else {
			document.documentElement.classList.remove("dark");
			this.toggleTarget.innerHTML = this.lightIcon;
		}
	}
	switchTheme() {
		if (this.isDarkMode) {
			document.documentElement.classList.remove("dark");
			this.toggleTarget.innerHTML = this.lightIcon;
		} else {
			document.documentElement.classList.add("dark");
			this.toggleTarget.innerHTML = this.darkIcon;
		}
		this.isDarkMode = !this.isDarkMode;
		this.savePreference()
	}

	savePreference() {
		const newTheme = this.isDarkMode ? "dark" : "light";
		console.log(newTheme);
		fetch("/update_theme", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
				"X-CSRF-Token": document.querySelector("meta[name=\"csrf-token\"]").getAttribute("content")
			},
			body: JSON.stringify({theme: newTheme})
		});
	}
}
