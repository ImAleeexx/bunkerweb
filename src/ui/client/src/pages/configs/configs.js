import { createApp } from "vue";
import Configs from "./Configs.vue";
import { createPinia } from "pinia";
import { getI18n } from "@utils/lang.js";

const pinia = createPinia();

createApp(Configs)
  .use(pinia)
  .use(getI18n(["custom_conf", "dashboard", "custom_inputs"]))
  .mount("#app");
