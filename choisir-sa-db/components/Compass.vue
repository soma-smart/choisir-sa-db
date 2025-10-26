<template>
    <div class="compass-container">
        <div class="compass-base-gradient">
            <img src="https://www.svgrepo.com/show/499816/database.svg" alt="Compass Base" class="compass-base" />
        </div>

        <div v-for="icon in positionedIcons" :key="icon.name" class="icon-wrapper" :style="icon.style">
            <img :src="icon.src" :alt="icon.name" class="icon" :class="{ active: icon.angle === currentTargetAngle }" />
        </div>

        <svg class="compass-needle" :style="needleStyle" viewBox="0 0 100 100">
            <polygon points="50,0 60,50 40,50" class="needle-tip" />
            <polygon points="50,100 60,50 40,50" class="needle-base" />
            <circle cx="50" cy="50" r="5" class="needle-center" />
        </svg>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';

// --- ICONS CONFIGURATION ---
const iconsData = ref([
    {
        name: 'Neo4j',
        src: '/databases/neo4j.png',
    },
    {
        name: 'Snowflake',
        src: '/databases/snowflake.png',
    },
    {
        name: 'MongoDB',
        src: '/databases/mongo.png',
    },
    {
        name: 'PostgreSQL',
        src: '/databases/postgres.png',
    },
    {
        name: 'Redis',
        src: '/databases/redis.png',
    },
    {
        name: 'ClickHouse',
        src: '/databases/clickhouse.png',
    }
]);

const needleRotation = ref(0);
const currentTargetAngle = ref(null);
let intervalId = null;
let needleTimeoutId = null;

const NEEDLE_TRANSITION_DURATION_MS = 1500;
// --- DYNAMIC CALCULATIONS ---

const positionedIcons = computed(() => {
    // ... (This computed property is unchanged)
    const count = iconsData.value.length;
    if (count === 0) return [];
    const radius = 45;
    const center = 50;
    return iconsData.value.map((icon, index) => {
        const angleDeg = (index / count) * 360;
        const angleRad = (angleDeg - 90) * (Math.PI / 180);
        const x = center + radius * Math.cos(angleRad);
        const y = center + radius * Math.sin(angleRad);
        return {
            ...icon,
            angle: angleDeg,
            style: {
                top: `${y}%`,
                left: `${x}%`,
            },
        };
    });
});

const targetAngles = computed(() => positionedIcons.value.map(icon => icon.angle));

const needleStyle = computed(() => ({
    transform: `translate(-50%, -50%) rotate(${needleRotation.value}deg)`,
}));

// --- LOGIC ---

function updateNeedle() {
    // Clear any pending highlight timeouts if we're moving again
    if (needleTimeoutId) {
        clearTimeout(needleTimeoutId);
    }

    const angles = targetAngles.value;
    if (angles.length === 0) return; // Do nothing if no icons

    // === MODIFICATION START ===

    let newTargetAngle;
    const previousAngle = currentTargetAngle.value; // Get the last highlighted angle

    if (angles.length === 1) {
        // If there's only one icon, just select it
        newTargetAngle = angles[0];
    } else {
        // Otherwise, keep picking a new one until it's different
        do {
            const randomIndex = Math.floor(Math.random() * angles.length);
            newTargetAngle = angles[randomIndex];
        } while (newTargetAngle === previousAngle);
    }

    // === MODIFICATION END ===


    // 1. De-highlight the current icon immediately
    currentTargetAngle.value = null;

    // 2. Add hesitation and start the needle rotation
    const hesitationOffset = (Math.random() - 0.5) * 20;
    needleRotation.value = newTargetAngle + hesitationOffset;

    // 3. Set a timeout to highlight the NEW icon *after* the needle finishes
    needleTimeoutId = setTimeout(() => {
        currentTargetAngle.value = newTargetAngle;
        needleTimeoutId = null;
    }, NEEDLE_TRANSITION_DURATION_MS - 300); // Using the value from your example
}

onMounted(() => {
    setTimeout(updateNeedle, 100);
    intervalId = setInterval(updateNeedle, 4000); // Using the value from your example
});

onUnmounted(() => {
    clearInterval(intervalId);
    if (needleTimeoutId) {
        clearTimeout(needleTimeoutId);
    }
});
</script>

<style scoped>
.compass-container {
    position: relative;
    width: 140px;
    height: 140px;
    margin: 40px auto;
    margin-left: 40px;
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
    filter: drop-shadow(6px 0 4px rgba(0, 0, 0, 0.4));
    /* Prevents glow from being clipped */
    overflow: visible;
}

/* (Req 3) Style the needle parts */
.needle-tip {
    fill: #E53935;
    /* Add a glow using the same color */
    filter: drop-shadow(0 0 5px #E53935) drop-shadow(0 0 8px rgba(255, 100, 100, 0.7));
}

.needle-base {
    fill: #424242;
}

.needle-center {
    fill: #333;
    stroke: #555;
    stroke-width: 1;
}

.icon-wrapper {
    position: absolute;
    /* Already centered by translate, which is correct */
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

    /* (Req 2) Default to grayscale */
    filter: grayscale(100%) drop-shadow(0px 0 4px rgba(0, 217, 255, 0.2)) drop-shadow(0px 0 12px rgba(0, 242, 255, 0.2));

    /* (Req 2) Add smooth transition */
    transition: filter 0.7s cubic-bezier(0.65, 0, 0.35, 1);

}

/* (Req 2) Active state for the pointed icon */
.icon.active {
    filter: grayscale(0%) drop-shadow(0px 0 6px rgba(0, 217, 255, 0.5)) drop-shadow(0px 0 16px rgba(0, 242, 255, 0.5));
    opacity: 1;
    transform: scale(1.1);
    transition: filter 0.7s cubic-bezier(0.65, 0, 0.35, 1), transform 0.5s cubic-bezier(0.65, 0, 0.35, 1);
    /* Add a slight pop */
}
</style>