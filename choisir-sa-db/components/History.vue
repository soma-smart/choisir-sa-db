<script setup>
// Ce composant accepte une "prop" appelée 'events'
// qui doit être un tableau d'objets (ex: { year: '...', text: '...' })
defineProps({
    events: {
        type: Array,
        required: true,
    },
})
</script>

<template>
    <div class="w-full px-10 pt-24 pb-20">

        <div class="absolute left-0 right-0 top-1/2 w-full h-1.5 bg-gray-300 -translate-y-1/2"></div>

        <div class="relative flex justify-between w-full">

            <div v-for="(event, index) in events" :key="event.year" class="relative flex-grow-0 flex-shrink-0"
                style="flex-basis: 16%;">

                <div class="relative flex flex-col items-center">

                    <div class="absolute text-center p-2 rounded-lg" style="min-width: 150px;"
                        :class="index % 2 === 0 ? 'bottom-full mb-5' : 'top-full mt-5'">
                        <span class="font-bold text-xl text-blue-600">{{ event.year }}</span>
                        <p class="text-sm opacity-90 leading-tight">{{ event.text }}</p>
                    </div>

                    <div class="w-5 h-5 bg-white border-4 border-blue-600 rounded-full z-10">
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>