<template>
    Coucou
    <div ref="playerContainer" class="asciinema-player-container">
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch } from 'vue'
// Note: asciinema-player v3+ provides an ES module with a create function
import { create as createPlayer } from 'asciinema-player'
// Define the Player instance type for TypeScript (optional but good practice)
import type { Player } from 'asciinema-player'

// Props definition
const props = defineProps({
    src: {
        type: String,
        required: true,
        default: '/hyperfine.cast' // Default to the requested file
    },
    // Example of passing options to the player
    autoPlay: {
        type: Boolean,
        default: false
    },
    loop: {
        type: Boolean,
        default: false
    },
    cols: {
        type: [Number, String],
        default: 80
    },
    rows: {
        type: [Number, String],
        default: 24
    }
    // You can add more props for other asciinema-player options
})

const playerContainer = ref<HTMLElement | null>(null)
let playerInstance: Player | null = null

const createAsciinemaPlayer = () => {
    if (playerContainer.value) {
        // The player's options, derived from component props
        const options = {
            autoPlay: props.autoPlay,
            loop: props.loop,
            cols: Number(props.cols),
            rows: Number(props.rows),
            // Add other options here as needed
        }

        // Create the player instance
        playerInstance = createPlayer(
            props.src,
            playerContainer.value,
            options
        )

        // Slidev note: You might need additional logic if the Slidev
        // <v-click> feature is used, as it might hide/show the component
        // without fully unmounting/remounting.
    }
}

const destroyAsciinemaPlayer = () => {
    if (playerInstance) {
        // There isn't an explicit `destroy` method, but unmounting the
        // container and setting the instance to null is the typical pattern.
        // The player cleans up its own elements when the container is removed.
        playerContainer.value!.innerHTML = ''
        playerInstance = null
    }
}

// Lifecycle hooks
onMounted(() => {
    createAsciinemaPlayer()
})

onUnmounted(() => {
    destroyAsciinemaPlayer()
})

// Optionally, re-create player if the `src` changes (e.g., in a dynamic slide)
watch(() => props.src, (newSrc, oldSrc) => {
    if (newSrc !== oldSrc) {
        destroyAsciinemaPlayer()
        createAsciinemaPlayer()
    }
})
</script>

<style scoped>
/* Optional: style the container to control size */
.asciinema-player-container {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Note: The player itself is highly styled by asciinema-player.css */
</style>