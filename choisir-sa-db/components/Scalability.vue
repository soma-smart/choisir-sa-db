<template>
    <div
        class="h-[450px] w-full rounded-lg bg-gradient-to-br from-pink-500 to-blue-500 dark:from-pink-900 dark:to-blue-900 p-3 flex flex-col gap-3">
        <!-- Top Section: Vertical Slider + Visualization + Stats -->
        <div class="flex gap-3 flex-1 min-h-0">
            <!-- Left: Vertical Slider (Y-axis) - Full Height with blur container -->
            <div
                class="w-16 bg-white/10 dark:bg-white/5 backdrop-blur-sm rounded-lg p-2 flex flex-col items-center gap-1">
                <span class="text-white dark:text-gray-200 font-semibold text-xs">⬆️</span>
                <span class="text-white dark:text-gray-200 font-semibold text-xs">Vertical</span>
                <p class="text-[10px] text-white/90 dark:text-gray-300 italic text-center mt-1">
                    Scale Up
                </p>
                <span
                    class="px-2 py-0.5 rounded-full bg-white/20 dark:bg-white/10 text-white dark:text-gray-200 text-xs font-semibold mb-1">
                    {{ verticalScale }}
                </span>
                <input type="range" v-model.number="verticalScale" min="1" max="10" orient="vertical"
                    class="flex-1 appearance-none cursor-pointer bg-gradient-to-b from-blue-400 to-red-500 dark:from-blue-600 dark:to-red-700 rounded-lg"
                    style="writing-mode: vertical-lr; direction: rtl; width: 8px;" />
                <p class="text-[10px] text-white/90 dark:text-gray-300 italic text-center mt-1">
                    Scale Down
                </p>
            </div>

            <!-- Center: Visualization -->
            <div class="flex-1 bg-white/95 dark:bg-gray-800/95 rounded-lg p-2 flex flex-col min-w-0">
                <!-- Servers -->
                <div class="flex gap-1 justify-center items-end flex-wrap flex-1 min-h-0">
                    <div v-for="index in horizontalScale" :key="index"
                        class="flex flex-col items-center gap-1 transition-all duration-300">
                        <svg :width="baseWidth" :height="serverHeight" viewBox="0 0 100 100"
                            class="transition-all duration-300 drop-shadow-sm" :style="{ height: serverHeight + 'px' }"
                            overflow="visible" preserveAspectRatio="xMidYMid meet">
                            <rect x="10" y="20" width="80" height="70" rx="4"
                                class="fill-gray-700 dark:fill-gray-600 stroke-gray-600 dark:stroke-gray-500"
                                stroke-width="2" />
                            <circle cx="20" cy="30" r="2" :fill="cpuColor" />
                            <!-- Drive Bays - using index to start from 0 -->
                            <rect v-for="(bay, bayIndex) in driveBays" :key="bay" x="25" :y="30 + (bayIndex * 7)"
                                width="60" height="5" rx="1"
                                class="fill-gray-600 dark:fill-gray-500 stroke-gray-500 dark:stroke-gray-400"
                                stroke-width="0.5" />
                            <text x="50" y="17" text-anchor="middle" font-size="7" :fill="cpuColor" font-weight="bold">
                                {{ cpuLabel }}
                            </text>
                        </svg>
                        <div class="bg-gray-100 dark:bg-gray-700 px-1.5 py-0.5 rounded text-[10px] text-center">
                            <div class="font-semibold text-gray-700 dark:text-gray-200">{{ cpuPower }}c</div>
                            <div class="font-semibold text-gray-700 dark:text-gray-200">{{ ramSize }}GB</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: Stats Column -->
            <div class="w-28 flex flex-col gap-2">
                <div class="bg-white/10 dark:bg-white/5 backdrop-blur-sm rounded p-2 text-center flex-1">
                    <div class="text-[10px] text-white/80 dark:text-gray-300 mb-0.5">Serveurs</div>
                    <div class="text-xl font-bold text-white dark:text-gray-100">{{ horizontalScale }}</div>
                </div>
                <div class="bg-white/10 dark:bg-white/5 backdrop-blur-sm rounded p-2 text-center flex-1">
                    <div class="text-[10px] text-white/80 dark:text-gray-300 mb-0.5">CPU/Serveur</div>
                    <div class="text-xl font-bold text-white dark:text-gray-100">{{ cpuPower }}</div>
                </div>
                <div class="bg-white/10 dark:bg-white/5 backdrop-blur-sm rounded p-2 text-center flex-1">
                    <div class="text-[10px] text-white/80 dark:text-gray-300 mb-0.5">Total de CPUs</div>
                    <div class="text-xl font-bold text-white dark:text-gray-100">{{ totalCPU }}</div>
                </div>
                <div class="bg-white/10 dark:bg-white/5 backdrop-blur-sm rounded p-2 text-center flex-1">
                    <div class="text-[10px] text-white/80 dark:text-gray-300 mb-0.5">RAM totale</div>
                    <div class="text-lg font-bold text-white dark:text-gray-100">{{ totalRAM }}GB</div>
                </div>
            </div>
        </div>

        <!-- Bottom Section: Horizontal Slider (X-axis) -->
        <div class="flex gap-3">
            <div class="w-16"></div> <!-- Spacer to align with vertical slider -->
            <div class="flex-1 bg-white/10 dark:bg-white/5 backdrop-blur-sm rounded-lg p-2">
                <div class="flex justify-between items-center mb-1">
                    <span class="text-white dark:text-gray-200 font-semibold text-xs">↔️ Horizontal</span>
                    <span
                        class="px-2 py-0.5 rounded-full bg-white/20 dark:bg-white/10 text-white dark:text-gray-200 text-xs font-semibold">
                        {{ horizontalScale }}
                    </span>
                </div>
                <input type="range" v-model.number="horizontalScale" min="1" max="10"
                    class="w-full h-1.5 rounded-lg appearance-none cursor-pointer bg-gradient-to-r from-green-400 to-green-600 dark:from-green-600 dark:to-green-800" />
                <div class="flex justify-between mt-0.5">
                    <p class="text-[10px] text-white/90 dark:text-gray-300 italic text-left w-1/2">
                        Scale In: Moins d'instances
                    </p>
                    <p class="text-[10px] text-white/90 dark:text-gray-300 italic text-right w-1/2">
                        Scale Out: Plus d'instances
                    </p>
                </div>
            </div>
            <div class="w-28"></div> <!-- Spacer to align with stats column -->
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const verticalScale = ref(1)
const horizontalScale = ref(1)
const baseWidth = 100

const serverHeight = computed(() => {
    return 60 + (verticalScale.value - 1) * 6.67
})

const driveBays = computed(() => {
    return Math.min(Math.ceil(verticalScale.value * 0.8), 8)
})

const cpuPower = computed(() => {
    const cores = [2, 4, 8, 16, 24, 32, 48, 64, 96, 128]
    return cores[verticalScale.value - 1]
})

const ramSize = computed(() => {
    const ram = [8, 16, 32, 64, 128, 256, 512, 768, 1024, 1536]
    return ram[verticalScale.value - 1]
})

const cpuLabel = computed(() => {
    if (verticalScale.value <= 3) return '€'
    if (verticalScale.value <= 6) return '€€'
    if (verticalScale.value <= 8) return '€€€'
    return '€€€€'
})

const cpuColor = computed(() => {
    if (verticalScale.value <= 3) return '#3498db'
    if (verticalScale.value <= 6) return '#f39c12'
    if (verticalScale.value <= 8) return '#e67e22'
    return '#e74c3c'
})

const totalCPU = computed(() => {
    return cpuPower.value * horizontalScale.value
})

const totalRAM = computed(() => {
    return ramSize.value * horizontalScale.value
})
</script>

<style scoped>
/* Slider thumb */
input[type="range"]::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 16px;
    height: 16px;
    border-radius: 50%;
    @apply bg-white dark:bg-gray-200 cursor-pointer shadow-md;
    transition: transform 0.2s;
}

input[type="range"]::-webkit-slider-thumb:hover {
    transform: scale(1.15);
}

input[type="range"]::-moz-range-thumb {
    width: 16px;
    height: 16px;
    border-radius: 50%;
    @apply bg-white dark:bg-gray-200 cursor-pointer shadow-md border-0;
    transition: transform 0.2s;
}

input[type="range"]::-moz-range-thumb:hover {
    transform: scale(1.15);
}

p {
    margin: 0;
}
</style>
