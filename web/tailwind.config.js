/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        Saira: ["Saira", "sans-serif"],
        Dancing: ["Dancing Script", "cursive"],
      }
    },
  },
  plugins: [
  ],
}
