<script setup lang="ts">
import { ref, computed, onUnmounted } from 'vue';
import { storeToRefs } from 'pinia';
import { useScriptStore } from '@/stores/script';
import confetti from 'canvas-confetti';

export interface NotificationOptions {
  confetti?: boolean;
  position?: 'tl' | 'tc' | 'tr' | 'lc' | 'rc' | 'bl' | 'bc' | 'br';
}

export interface Notification {
  id: string;
  title: string;
  text: string;
  type: 'info' | 'warning' | 'success' | 'error';
  duration?: number;
  timestamp: number;
  options?: NotificationOptions;
}

const props = defineProps<{
  position: 'top-right' | 'top-left' | 'top-center' | 'bottom-right' | 'bottom-left' | 'bottom-center' | 'left-center' | 'right-center';
}>();

const { config } = storeToRefs(useScriptStore());
const notifications = ref<Notification[]>([]);
const timers = new Map<string, NodeJS.Timeout>();

const positionClasses = computed(() => {
  const positions = {
    'top-right': 'top-4 right-4',
    'top-left': 'top-4 left-4',
    'top-center': 'top-4 left-1/2 transform -translate-x-1/2',
    'bottom-right': 'bottom-4 right-4',
    'bottom-left': 'bottom-4 left-4',
    'bottom-center': 'bottom-4 left-1/2 transform -translate-x-1/2',
    'left-center': 'top-1/2 left-4 transform -translate-y-1/2',
    'right-center': 'top-1/2 right-4 transform -translate-y-1/2'
  };
  return positions[props.position] || positions['left-center'];
});

const getNotificationIcon = (type: string) => {
  const icons = {
    success: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5">
      <path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12zm13.36-1.814a.75.75 0 10-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.14-.094l3.75-5.25z" clip-rule="evenodd" />
    </svg>`,
    error: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5">
      <path fill-rule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25zm-1.72 6.97a.75.75 0 10-1.06 1.06L10.94 12l-1.72 1.72a.75.75 0 101.06 1.06L12 13.06l1.72 1.72a.75.75 0 101.06-1.06L13.06 12l1.72-1.72a.75.75 0 10-1.06-1.06L12 10.94l-1.72-1.72z" clip-rule="evenodd" />
    </svg>`,
    warning: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5">
      <path fill-rule="evenodd" d="M9.401 3.003c1.155-2 4.043-2 5.197 0l7.355 12.748c1.154 2-.29 4.5-2.599 4.5H4.645c-2.309 0-3.752-2.5-2.598-4.5L9.4 3.003zM12 8.25a.75.75 0 01.75.75v3.75a.75.75 0 01-1.5 0V9a.75.75 0 01.75-.75zm0 8.25a.75.75 0 100-1.5.75.75 0 000 1.5z" clip-rule="evenodd" />
    </svg>`,
    info: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5">
      <path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12zm8.706-1.442c1.146-.573 2.437.463 2.126 1.706l-.709 2.836.042-.02a.75.75 0 01.67 1.34l-.04.022c-1.147.573-2.438-.463-2.127-1.706l.71-2.836-.042.02a.75.75 0 11-.671-1.34l.041-.022zM12 9a.75.75 0 100-1.5.75.75 0 000 1.5z" clip-rule="evenodd" />
    </svg>`
  };
  return icons[type] || icons.info;
};

const getNotificationStyles = computed(() => (type: string) => {
  if (!config.value?.Colors) return {};

  const colors = config.value.Colors;
  const accentColor = colors[type] || colors.info;

  return {
    backgroundColor: colors.background,
    borderLeftColor: accentColor,
    '--text-primary': colors.textPrimary,
    '--text-secondary': colors.textSecondary,
    '--accent-color': accentColor
  };
});

const getAnimationClass = () => {
  if (props.position.includes('left')) return 'animate-slide-left';
  if (props.position.includes('right')) return 'animate-slide-right';
  if (props.position.includes('top')) return 'animate-slide-top';
  if (props.position.includes('bottom')) return 'animate-slide-bottom';
  return 'animate-slide-left';
};

const getProgressAnimation = () => {
  if (props.position === 'tc' || props.position === 'bc') return 'shrink-left';
  if (props.position.includes('left')) return 'shrink-left';
  if (props.position.includes('right')) return 'shrink-right';
  return 'shrink-left';
};

const triggerConfetti = () => {
  let originX = 0.5;
  let originY = 0.5;

  if (props.position.includes('left')) originX = 0.1;
  else if (props.position.includes('right')) originX = 0.9;
  else if (props.position.includes('center')) originX = 0.5;

  if (props.position.includes('top')) originY = 0.1;
  else if (props.position.includes('bottom')) originY = 0.9;
  else if (props.position.includes('center')) originY = 0.5;

  confetti({
    particleCount: 100,
    spread: 70,
    origin: { x: originX, y: originY },
    colors: ['#10B981', '#3B82F6', '#F59E0B', '#EF4444', '#8B5CF6'],
    disableForReducedMotion: true
  });
};

const addNotification = (notification: Omit<Notification, 'id' | 'timestamp'>) => {
  const id = Math.random().toString(36).substring(7);
  const newNotification: Notification = {
    ...notification,
    id,
    timestamp: Date.now(),
    duration: notification.duration || 5000
  };

  notifications.value.push(newNotification);

  if (notification.options?.confetti) {
    setTimeout(() => {
      triggerConfetti();
    }, 100);
  }

  if (newNotification.duration && newNotification.duration > 0) {
    const timer = setTimeout(() => {
      removeNotification(id);
    }, newNotification.duration);
    timers.set(id, timer);
  }
};

const getOutAnimationClass = () => {
  if (props.position.includes('left')) return 'animate-out-left';
  if (props.position.includes('right')) return 'animate-out-right';
  if (props.position.includes('top')) return 'animate-out-top';
  if (props.position.includes('bottom')) return 'animate-out-bottom';
  return 'animate-out-left';
};

const removeNotification = (id: string) => {
  const timer = timers.get(id);
  if (timer) {
    clearTimeout(timer);
    timers.delete(id);
  }

  const index = notifications.value.findIndex(n => n.id === id);
  if (index > -1) {
    const element = document.getElementById(`notification-${id}`);
    const outClass = getOutAnimationClass();
    if (element && !element.classList.contains(outClass)) {
      element.classList.remove('animate-slide-left', 'animate-slide-right', 'animate-slide-top', 'animate-slide-bottom');
      element.classList.add(outClass);
      setTimeout(() => {
        const currentIndex = notifications.value.findIndex(n => n.id === id);
        if (currentIndex > -1) {
          notifications.value.splice(currentIndex, 1);
        }
      }, 300);
    } else if (!element) {
      notifications.value.splice(index, 1);
    }
  }
};

defineExpose({
  addNotification
});

onUnmounted(() => {
  timers.forEach(timer => clearTimeout(timer));
  timers.clear();
});
</script>

<template>
  <div :class="['notification-container', positionClasses]">
    <TransitionGroup name="notification">
      <div
        v-for="notification in notifications"
        :key="notification.id"
        :id="`notification-${notification.id}`"
        :class="['notification-card', getAnimationClass()]"
        :style="getNotificationStyles(notification.type)"
        role="alert"
      >
        <div class="notification-content">
          <div class="notification-icon" v-html="getNotificationIcon(notification.type)">
          </div>

          <div class="notification-text-wrapper">
            <h3 v-if="notification.title" class="notification-title">
              {{ notification.title }}
            </h3>
            <p v-if="notification.text" :class="notification.title ? 'notification-description' : 'notification-description-large'">
              {{ notification.text }}
            </p>
          </div>
        </div>

        <div v-if="notification.duration && notification.duration > 0" class="notification-progress">
          <div
            :class="['notification-progress-bar', `progress-${getProgressAnimation()}`]"
            :style="{
              animationDuration: `${notification.duration}ms`,
              backgroundColor: 'var(--accent-color)'
            }"
          ></div>
        </div>
      </div>
    </TransitionGroup>
  </div>
</template>

<style scoped>
.notification-container {
  @apply fixed z-50 flex flex-col gap-2 w-[320px];
}

.notification-card {
  @apply relative overflow-hidden min-w-[280px] rounded-[12px];
  @apply transition-all duration-300 ease-out;
  @apply border-l-[3px];
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3),
              0 2px 4px -1px rgba(0, 0, 0, 0.2),
              0 10px 15px -3px rgba(0, 0, 0, 0.3);
}

.notification-card:hover {
  @apply transform scale-[1.01];
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.4),
              0 4px 6px -2px rgba(0, 0, 0, 0.3),
              0 20px 25px -5px rgba(0, 0, 0, 0.3);
}

.notification-content {
  @apply flex items-start gap-3 px-4 py-3;
  background: linear-gradient(135deg, rgba(26, 27, 38, 0.95) 0%, rgba(26, 27, 38, 0.98) 100%);
}

.notification-icon {
  @apply flex-shrink-0 mt-0.5;
  @apply opacity-90;
  color: var(--accent-color);
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
}

.notification-text-wrapper {
  @apply flex-1 min-w-0;
}

.notification-title {
  @apply font-medium text-[13px] tracking-wide leading-tight;
  color: var(--text-primary);
  text-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.notification-description {
  @apply text-[11px] mt-1 leading-relaxed;
  @apply opacity-85;
  color: var(--text-secondary);
}

.notification-description-large {
  @apply text-[14px] leading-relaxed font-medium;
  @apply opacity-95;
  color: var(--text-primary);
  text-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

.notification-progress {
  @apply absolute bottom-0 left-0 right-0;
  @apply h-[2px];
  background: rgba(0,0,0,0.2);
}

.notification-progress-bar {
  @apply h-full;
  @apply opacity-80;
  box-shadow: 0 0 4px var(--accent-color);
  animation-timing-function: linear;
  animation-fill-mode: forwards;
}

@keyframes slideInLeft {
  from { opacity: 0; transform: translateX(-100%); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes slideOutLeft {
  from { opacity: 1; transform: translateX(0); }
  to { opacity: 0; transform: translateX(-100%); }
}

@keyframes slideInRight {
  from { opacity: 0; transform: translateX(100%); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes slideOutRight {
  from { opacity: 1; transform: translateX(0); }
  to { opacity: 0; transform: translateX(100%); }
}

@keyframes slideInTop {
  from { opacity: 0; transform: translateY(-100%); }
  to { opacity: 1; transform: translateY(0); }
}
@keyframes slideOutTop {
  from { opacity: 1; transform: translateY(0); }
  to { opacity: 0; transform: translateY(-100%); }
}

@keyframes slideInBottom {
  from { opacity: 0; transform: translateY(100%); }
  to { opacity: 1; transform: translateY(0); }
}
@keyframes slideOutBottom {
  from { opacity: 1; transform: translateY(0); }
  to { opacity: 0; transform: translateY(100%); }
}

.animate-slide-left {
  animation: slideInLeft 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.animate-slide-right {
  animation: slideInRight 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.animate-slide-top {
  animation: slideInTop 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.animate-slide-bottom {
  animation: slideInBottom 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.animate-out-left {
  animation: slideOutLeft 0.3s ease-in;
}
.animate-out-right {
  animation: slideOutRight 0.3s ease-in;
}
.animate-out-top {
  animation: slideOutTop 0.3s ease-in;
}
.animate-out-bottom {
  animation: slideOutBottom 0.3s ease-in;
}

@keyframes shrinkLeft {
  from {
    width: 100%;
    transform-origin: left center;
  }
  to {
    width: 0%;
    transform-origin: left center;
  }
}

@keyframes shrinkRight {
  from {
    width: 100%;
    transform-origin: right center;
    margin-left: 0;
  }
  to {
    width: 0%;
    transform-origin: right center;
    margin-left: 100%;
  }
}

.progress-shrink-left {
  animation-name: shrinkLeft;
}

.progress-shrink-right {
  animation-name: shrinkRight;
}

.notification-enter-active,
.notification-leave-active {
  @apply transition-all duration-300 ease-in-out;
}

.notification-enter-from {
  @apply opacity-0 transform translate-x-full;
}

.notification-leave-to {
  @apply opacity-0 transform translate-x-full;
}

.notification-move {
  @apply transition-transform duration-300 ease-in-out;
}
</style>