import { createApp } from "vue";
import { createPinia } from "pinia";
import App from "./App.vue";
import "./assets/css/style.css";
import "./assets/css/index.css";

const pinia = createPinia();
const app = createApp(App);

app
  .use(pinia)
  .mount("#app");