<template>
    <div ref="chartContainer" class="data-bubble-chart">
        <svg :width="width" :height="height" ref="svgElement" @click="toggleLayout"></svg>
    </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed, watch } from 'vue';
import * as d3 from 'd3';

// Define the data for the bubbles
const data = ref([
    { id: 1, name: 'Postgres', type: 'Relational', logo: '/databases/postgres.png', radius: 30 },
    { id: 2, name: 'Redis', type: 'In Memory', logo: '/databases/redis.png', radius: 30 },
    { id: 3, name: 'MySQL', type: 'Relational', logo: '/databases/mysql.png', radius: 30 },
    { id: 4, name: 'Snowflake', type: 'Hybrid', logo: '/databases/snowflake.png', radius: 30 },
    { id: 5, name: 'Databend', type: 'Hybrid', logo: '/databases/databend.png', radius: 30 },
]);

// Component dimensions
const width = 800;
const height = 500;

// Refs for the component
const chartContainer = ref(null);
const svgElement = ref(null);

// State for layout toggle
const isGrouped = ref(false);

// Configuration for groups (centers for the clustered view)
const groupCenters = computed(() => {
    // Get unique types
    const types = Array.from(new Set(data.value.map(d => d.type)));
    const numGroups = types.length;
    // Calculate horizontal positions for groups
    const centerX = width / 2;
    const spacing = width / (numGroups + 1);
    return types.reduce((acc, type, i) => {
        acc[type] = {
            x: spacing * (i + 1), // Distribute centers
            y: height / 2,
        };
        return acc;
    }, {});
});

// Create a color scale for types
const colorScale = d3.scaleOrdinal()
    .domain(['Relational', 'In Memory', 'Hybrid'])
    .range(['#4c78a8', '#f58518', '#e45756']); // Example colors

let svg, simulation;


// Function to initialize the D3 force simulation
const initSimulation = () => {
    simulation = d3.forceSimulation(data.value)
        // Add a force to prevent bubbles from overlapping
        .force('collide', d3.forceCollide().radius(d => d.radius + 1.5).strength(0.8))
        // Add a linking force to center the bubbles based on current layout
        .force('x', d3.forceX(d => getTargetPosition(d).x).strength(isGrouped.value ? 0.15 : 0.05))
        .force('y', d3.forceY(d => getTargetPosition(d).y).strength(isGrouped.value ? 0.15 : 0.05))
        // Start simulation immediately with a lower alpha to prevent aggressive movement on load
        .alpha(0.5).alphaTarget(0.01)
        .on('tick', ticked);

    // Stop the simulation after a period of stability for the initial view
    setTimeout(() => simulation.alphaTarget(0).alphaDecay(0.01), 1000);
};

// Function to get the target (x, y) position for a node
const getTargetPosition = (d) => {
    if (isGrouped.value) {
        // Clustered view: target is the group center
        return groupCenters.value[d.type];
    } else {
        // Random scatter view: target is a random point within the center area
        return {
            x: width / 2 + (Math.random() - 0.5) * 200,
            y: height / 2 + (Math.random() - 0.5) * 150,
        };
    }
};

// Function called on every simulation tick
const ticked = () => {
    // Update the position of circles
    svg.selectAll('.node-group')
        .attr('transform', d => `translate(${d.x}, ${d.y})`);

    // Update the position of group labels (only visible when grouped)
    svg.selectAll('.group-label')
        .attr('x', d => groupCenters.value[d].x)
        .attr('y', d => groupCenters.value[d].y - 100); // Position above the cluster
};

// Function to render or update the nodes (bubbles)
const updateNodes = () => {
    // 1. Data binding: Join data to SVG groups
    const node = svg.selectAll('.node-group')
        .data(data.value, d => d.id)
        .join(
            enter => {
                const g = enter.append('g')
                    .attr('class', 'node-group')
                    // Set initial random position
                    .attr('transform', d => `translate(${width * Math.random()}, ${height * Math.random()})`);

                // Append the main circle
                g.append('circle')
                    .attr('r', d => d.radius)
                    .attr('fill', d => colorScale(d.type))
                    .attr('stroke', '#fff')
                    .attr('stroke-width', 2);

                // Append the logo (using an image element)
                g.append('image')
                    .attr('xlink:href', d => d.logo) // **NOTE: Update paths/use proper assets**
                    .attr('width', d => d.radius * 1.5)
                    .attr('height', d => d.radius * 1.5)
                    .attr('x', d => -d.radius * 0.75) // Center the image
                    .attr('y', d => -d.radius * 0.75);

                // Append the name label below the logo
                g.append('text')
                    .attr('text-anchor', 'middle')
                    .attr('dy', d => d.radius + 15)
                    .attr('class', 'bubble-label')
                    .text(d => d.name);

                return g;
            },
            update => update, // No specific update logic needed here
            exit => exit.remove()
        );

    // 2. Add group labels (only relevant in grouped mode)
    const groupLabels = Array.from(new Set(data.value.map(d => d.type)));

    svg.selectAll('.group-label')
        .data(groupLabels)
        .join(
            enter => enter.append('text')
                .attr('class', 'group-label')
                .attr('text-anchor', 'middle')
                .attr('font-size', '1.5em')
                .attr('font-weight', 'bold')
                .attr('fill', '#333')
                .attr('opacity', 0) // Start invisible
                .text(d => d),
            update => update,
            exit => exit.remove()
        )
        // Update label visibility based on state
        .transition().duration(500)
        .attr('opacity', isGrouped.value ? 1 : 0);
};

// --- Lifecycle and Watchers ---

onMounted(() => {
    // Initialize SVG selection
    svg = d3.select(svgElement.value);

    // Initial render
    updateNodes();
    initSimulation();
});

onUnmounted(() => {
    // TODO: reset simulation to start cleanly

});

// Watch for layout changes to update the simulation forces
watch(isGrouped, (newVal) => {
    // Update the forces in the simulation
    simulation
        .force('x', d3.forceX(d => getTargetPosition(d).x).strength(newVal ? 0.15 : 0.05))
        .force('y', d3.forceY(d => getTargetPosition(d).y).strength(newVal ? 0.15 : 0.05));

    // Restart the simulation with a small kick (alpha) to initiate movement
    simulation.alpha(1).restart();

    // Update visibility of group labels
    svg.selectAll('.group-label')
        .transition().duration(500)
        .attr('opacity', newVal ? 1 : 0);
});

// --- User Interaction ---

// Toggle the layout state on click
const toggleLayout = () => {
    isGrouped.value = !isGrouped.value;
};
</script>

<style scoped>
.data-bubble-chart {
    cursor: pointer;
}

.bubble-label {
    fill: #333;
    font-size: 0.8em;
}

/* Image styling is handled by d3 attributes, but this ensures a clean base */
svg image {
    pointer-events: none;
    /* Allows click-through to the SVG element */
}
</style>