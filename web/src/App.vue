<script setup lang="ts">
import { ref } from "vue";
import { useScriptStore } from "@/stores/script";
import { storeToRefs } from "pinia";
import useNui from "./composables/useNui";
import NotificationContainer from "./components/NotificationContainer.vue";

const { config } = storeToRefs(useScriptStore());

const topRightContainer = ref<InstanceType<typeof NotificationContainer>>();
const topLeftContainer = ref<InstanceType<typeof NotificationContainer>>();
const topCenterContainer = ref<InstanceType<typeof NotificationContainer>>();
const bottomRightContainer = ref<InstanceType<typeof NotificationContainer>>();
const bottomLeftContainer = ref<InstanceType<typeof NotificationContainer>>();
const bottomCenterContainer = ref<InstanceType<typeof NotificationContainer>>();
const leftCenterContainer = ref<InstanceType<typeof NotificationContainer>>();
const rightCenterContainer = ref<InstanceType<typeof NotificationContainer>>();

interface NotifyOptions {
  confetti?: boolean;
  position?: 'tl' | 'tc' | 'tr' | 'lc' | 'rc' | 'bl' | 'bc' | 'br';
}

interface Notify {
  title: string;
  text: string;
  type?: "info" | "warn" | "success" | "error";
  length?: number; // in ms
  options?: NotifyOptions;
}

const playNotification = (type?: "error" | "warn") => {
  let url = new URL("@/assets/notification.mp3", import.meta.url);

  if (type) {
    switch (type) {
      case "error":
        url = new URL("@/assets/notification_error.mp3", import.meta.url);
        break;
      case "warn":
        url = new URL("@/assets/notification_warn.mp3", import.meta.url);
        break;
    }
  }

  const audio = new Audio(url);
  audio.play();
};

useNui("notify", ({ title, text, type, length, options }: Notify) => {
  const notificationType = type === 'warn' ? 'warning' : (type || 'info');

  const position = options?.position || config.value.Position;

  let container;
  switch (position) {
    case 'tl':
      container = topLeftContainer.value;
      break;
    case 'tc':
      container = topCenterContainer.value;
      break;
    case 'tr':
      container = topRightContainer.value;
      break;
    case 'lc':
      container = leftCenterContainer.value;
      break;
    case 'rc':
      container = rightCenterContainer.value;
      break;
    case 'bl':
      container = bottomLeftContainer.value;
      break;
    case 'bc':
      container = bottomCenterContainer.value;
      break;
    case 'br':
      container = bottomRightContainer.value;
      break;
    default:
      container = leftCenterContainer.value;
      break;
  }

  if (container) {
    container.addNotification({
      title,
      text,
      type: notificationType as any,
      duration: length,
      options
    });
  }

  if (type === 'error' || type === 'warn') {
    playNotification(type);
  } else if (type) {
    playNotification();
  }
});


</script>

<template>
  <div class="dark">
    <NotificationContainer ref="topLeftContainer" position="top-left" />
    <NotificationContainer ref="topCenterContainer" position="top-center" />
    <NotificationContainer ref="topRightContainer" position="top-right" />
    <NotificationContainer ref="leftCenterContainer" position="left-center" />
    <NotificationContainer ref="rightCenterContainer" position="right-center" />
    <NotificationContainer ref="bottomLeftContainer" position="bottom-left" />
    <NotificationContainer ref="bottomCenterContainer" position="bottom-center" />
    <NotificationContainer ref="bottomRightContainer" position="bottom-right" />
  </div>
</template>

<style>
@import './assets/css/index.css';
</style>