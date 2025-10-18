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
    return props.src || $slidev.configs.corner_logo || 'https://www.soma-smart.com/_astro/soma-big.CJYqUrzs_Z1T2wG6.webp'
})
</script>

<template>
    <div class="slidev-logo absolute bottom-0 left-4" style="opacity: 0.5;">
        <img :src="logoSrc" alt="Logo" class="h-12" />
    </div>
</template>