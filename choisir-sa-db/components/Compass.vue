<template>
    <div class="compass-container">
        <div class="compass-base-gradient">
            <img src="https://www.svgrepo.com/show/499816/database.svg" alt="Compass Base" class="compass-base" />
        </div>
        <div v-for="icon in icons" :key="icon.name" class="icon-wrapper" :style="icon.style">
            <img :src="icon.src" :alt="icon.name" class="icon" />
        </div>
        <svg class="compass-needle" :style="needleStyle" viewBox="0 0 100 100">
            <polygon points="50,0 60,50 40,50" fill="#E53935" />
            <polygon points="50,100 60,50 40,50" fill="#424242" />
            <circle cx="50" cy="50" r="5" fill="#333" />
        </svg>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';

// --- ICONS CONFIGURATION ---
const icons = ref([
    {
        name: 'Relational',
        src: 'https://cdn.freebiesupply.com/logos/large/2x/neo4j-logo-png-transparent.png',
        angle: 0, // North
        style: { top: '5%', left: '50%' },
    },
    {
        name: 'Graph',
        src: 'https://registry.npmmirror.com/@lobehub/icons-static-png/latest/files/dark/snowflake-color.png',
        angle: 90, // East
        style: { top: '50%', left: '95%' },
    },
    {
        name: 'Treasure',
        src: 'https://img.icons8.com/?size=1200&id=DUsKDDZsg8FT&format=png',
        angle: 180, // South
        style: { top: '95%', left: '50%' },
    },
    {
        name: 'Tree',
        src: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Postgresql_elephant.svg/1163px-Postgresql_elephant.svg.png',
        angle: 270, // West
        style: { top: '50%', left: '5%' },
    },
]);

const targetAngles = icons.value.map(icon => icon.angle);

const needleRotation = ref(0);
let intervalId = null;

const needleStyle = computed(() => ({
    // The rotation logic remains the same
    transform: `translate(-50%, -50%) rotate(${needleRotation.value}deg)`,
}));

function updateNeedle() {
    const randomIndex = Math.floor(Math.random() * targetAngles.length);
    const targetAngle = targetAngles[randomIndex];
    const hesitationOffset = (Math.random() - 0.5) * 40; // +/- 20 degrees
    needleRotation.value = targetAngle + hesitationOffset;
}

onMounted(() => {
    intervalId = setInterval(updateNeedle, 2500);
});

onUnmounted(() => {
    clearInterval(intervalId);
});
</script>

<style scoped>
.compass-container {
    position: relative;
    width: 140px;
    height: 140px;
    margin: 40px auto;
    margin-left: 40px
}

.compass-base {
    width: 100%;
    height: 100%;
    filter: drop-shadow(4px 0 3px rgba(0, 0, 0, 0.4));
}

.compass-base-gradient {
    filter: hue-rotate(60deg) brightness(0.6) contrast(1.2) saturate(1.5);
}


.compass-needle {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 90%;
    height: 90%;
    transition: transform 1.5s cubic-bezier(0.65, 0, 0.35, 1);
    /* add shadow */
    filter: drop-shadow(6px 0 4px rgba(0, 0, 0, 0.4));
}

.icon-wrapper {
    position: absolute;
    transform: translate(-50%, -50%);
    width: 54px;
    height: 54px;
    display: flex;
    justify-content: center;
    align-items: center;
}

.icon {
    width: 50px;
    height: 50px;
    filter: drop-shadow(0px 0 4px rgba(0, 217, 255, 0.2)) drop-shadow(0px 0 12px rgba(0, 242, 255, 0.2));
}
</style>