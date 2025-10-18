<script setup>
import { computed } from 'vue'
import { useSlideContext } from '@slidev/client'

// Access global theme configurations from frontmatter
const { $slidev } = useSlideContext()

// Define props with a default value for the logo
const props = defineProps({
    src: {
        type: String,
        default: null, // Default is null, we'll use the global config as the primary default
    },
})

// Determine the final logo source
// Priority: 1. Prop passed directly to component -> 2. Global `logo` in frontmatter -> 3. Hardcoded default
const logoSrc = computed(() => {
    return props.src || $slidev.configs.logo || 'https://www.soma-smart.com/_astro/soma.CaF7tOdv_Z15ElNo.svg'
})
</script>

<template>
    <div class="slidev-logo absolute top-4 right-4" style="opacity: 0.5;">
        <img :src="logoSrc" alt="Logo" class="h-6" />
    </div>
</template>