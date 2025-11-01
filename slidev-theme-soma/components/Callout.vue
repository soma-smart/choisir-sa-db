<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps({
    type: {
        type: String,
        default: 'info', // info, warning, danger, success, etc.
        validator: (value: string) => ['info', 'warning', 'success', 'danger'].includes(value)
    },
})

// Détermine les classes de couleur Tailwind/UnoCSS basées sur le type
const colorClasses = computed(() => {
    switch (props.type) {
        case 'warning':
            return {
                // LIGHT mode classes
                bg: 'bg-yellow-50',
                border: 'border-yellow-300',
                text: 'text-yellow-900',
                icon: 'text-yellow-500',
                // DARK mode classes
                darkBg: 'dark:bg-yellow-900/20', // Fond sombre et transparent
                darkBorder: 'dark:border-yellow-700', // Bordure plus foncée
                darkText: 'dark:text-yellow-200', // Texte clair
                darkIcon: 'dark:text-yellow-500', // Icône clair/moyen
            }
        case 'success':
            return {
                bg: 'bg-green-50',
                border: 'border-green-300',
                text: 'text-green-900',
                icon: 'text-green-500',

                darkBg: 'dark:bg-green-900/20',
                darkBorder: 'dark:border-green-700',
                darkText: 'dark:text-green-200',
                darkIcon: 'dark:text-green-500',
            }
        case 'danger':
            return {
                bg: 'bg-red-50',
                border: 'border-red-300',
                text: 'text-red-900',
                icon: 'text-red-500',

                darkBg: 'dark:bg-red-900/20',
                darkBorder: 'dark:border-red-700',
                darkText: 'dark:text-red-200',
                darkIcon: 'dark:text-red-500',
            }
        case 'info':
        default:
            return {
                bg: 'bg-blue-50',
                border: 'border-blue-300',
                text: 'text-blue-900',
                icon: 'text-blue-500',

                darkBg: 'dark:bg-blue-900/20',
                darkBorder: 'dark:border-blue-700',
                darkText: 'dark:text-blue-200',
                darkIcon: 'dark:text-blue-500',
            }
    }
})
</script>

<template>
    <div class="flex items-start gap-3 p-4 rounded-lg border shadow-sm my-4" :class="[
        // LIGHT Mode classes
        colorClasses.bg,
        colorClasses.border,
        colorClasses.text,
        // DARK Mode classes
        colorClasses.darkBg,
        colorClasses.darkBorder,
        colorClasses.darkText
    ]">
        <div class="w-6 h-6 flex-shrink-0 mt-0.5" :class="[colorClasses.icon, colorClasses.darkIcon]">

            <svg v-if="type === 'info' || type === 'warning' || type === 'danger'" xmlns="http://www.w3.org/2000/svg"
                class="w-full h-full" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2" fill="none" />
                <path stroke="currentColor" stroke-width="2" stroke-linecap="round" d="M12 8v4m0 4h.01" />
            </svg>

            <svg v-else-if="type === 'success'" xmlns="http://www.w3.org/2000/svg" class="w-full h-full" fill="none"
                viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>

        </div>

        <div class="flex-1">
            <slot />
        </div>
    </div>
</template>