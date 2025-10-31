import { ref, onMounted, onUnmounted } from 'vue';

export default function useNui(action, handler) {
  const savedHandler = ref(handler);

  const eventListener = (event) => {
    if (event.data.action == action && savedHandler.value) {
      savedHandler.value(event.data.data);
    }
  };

  onMounted(() => window.addEventListener('message', eventListener));
  onUnmounted(() => window.removeEventListener('message', eventListener));
}