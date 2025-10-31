import { ref } from "vue";
import { defineStore } from "pinia";
import fetchNui from "@/utils/fetchNui";

export const useScriptStore = defineStore("script", () => {
  const config = ref();

  fetchNui("fetchConfig").then((fetchedConfig) => {
    if (!fetchedConfig) console.log("No config found!");

    config.value = fetchedConfig;
  });

  return {
    config,
  };
});
