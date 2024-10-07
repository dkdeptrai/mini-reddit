import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["toggle"]
	static values = {
		theme: String,
		darkIcon: String,
		lightIcon: String
	}

	connect() {
		this.initializeTheme()
	}

	async initializeTheme() {
		const storedTheme = localStorage.getItem("theme") || await this.fetchThemeFromServer()
		this.applyTheme(storedTheme)
	}

	async fetchThemeFromServer() {
		try {
			const response = await fetch("/load_theme")
			const data = await response.json()
			return data.theme
		} catch (error) {
			console.error("Error fetching theme:", error)
			return "light" // Default to light theme if fetch fails
		}
	}

	applyTheme(theme) {
		this.themeValue = theme
		localStorage.setItem("theme", theme)
		document.documentElement.classList.toggle("dark", theme === "dark")
		this.updateToggleIcon()
	}

	updateToggleIcon() {
		this.toggleTarget.innerHTML = this.themeValue === "dark" ? this.darkIconValue : this.lightIconValue
	}

	async switchTheme() {
		const newTheme = this.themeValue === "dark" ? "light" : "dark"
		this.applyTheme(newTheme)
		await this.savePreference(newTheme)
	}

	async savePreference(theme) {
		try {
			const response = await fetch("/update_theme", {
				method: "POST",
				headers: {
					"Content-Type": "application/json",
					"X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
				},
				body: JSON.stringify({ theme })
			})
			if (!response.ok) throw new Error("Failed to save theme preference")
		} catch (error) {
			console.error("Error saving theme preference:", error)
		}
	}
}
