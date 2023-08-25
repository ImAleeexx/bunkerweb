import { defineStore } from "pinia";
interface config {
  [key: string]: any;
}

export const useConfigStore = defineStore("config", () => {
  const data: config = ref({ global: {}, services: {} });

  function updateConf(context: string, id: string, value: string) {
    if (!context || !id) return;
    data.value[context][id] = value;
  }

  return { data, updateConf };
});

export const useFeedbackStore = defineStore("feedback", () => {
  const data: any = ref([
    { type: "success", message: "test feedback", status: 200 },
  ]);

  async function addFeedback(type: string, status: string, message: string) {
    data.value.push({ type: type, status: status, message: message });
  }

  function removeFeedback(id: number) {
    data.value.splice(id, 1);
  }

  return { data, addFeedback, removeFeedback };
});
