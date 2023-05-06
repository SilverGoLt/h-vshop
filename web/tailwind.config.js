/** @type {import('tailwindcss').Config} */
export default {
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
  plugins: [],
}

