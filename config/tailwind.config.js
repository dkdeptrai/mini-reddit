const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
	content: [
		"./public/*.html",
		"./app/helpers/**/*.rb",
		"./app/javascript/**/*.js",
		"./app/views/**/*.{erb,haml,html,slim}"
	],
	theme: {
		extend: {
			fontFamily: {
				sans: ["Inter var", ...defaultTheme.fontFamily.sans],
			},
			colors: {
				primary: {
					light: "#181B1F",
					dark: "#BACAD3"

				},
				secondary: {
					light: "#E7EBEE",
					dark: "#2B3337",
				},
				background: {
					light: "#FFFFFF",
					dark: "#0F1012"
				},
				text: {
					light: "#181B1F",
					dark: "#BACAD3",
				},
				border: {
					light: "#CBCCCA",
					dark: "#3F4142"
				},
				accent: {
					light: "#E5ECEF",
					dark: "#2A3336"
				},
				hover: {
					light: "#E7EBEE",
					dark: "#DCE5E9",
				},

			}
		},
	},
	darkMode: "class",
	variants: {
		extend: {
			backgroundColor: ['dark'],
			textColor: ['dark'],
			borderColor: ['dark'],
			placeholderColor: ['dark'],
		}
	},
	plugins:
		[
			require("@tailwindcss/forms"),
			require("@tailwindcss/typography"),
			require("@tailwindcss/container-queries"),
		],
};
