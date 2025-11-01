<template>
    <div ref="chartContainer" class="data-bubble-chart">
        <svg :width="width" :height="height" ref="svgElement"></svg>
    </div>
</template>

<script setup>
import { ref, computed, watch, nextTick } from 'vue';
import { useIsSlideActive, useDarkMode, useSlideContext } from '@slidev/client'
import * as d3 from 'd3';

// Component dimensions
const width = 800;
const height = 400;

// --- MODIFIED DATA ---
// Replaced the 'type' field with 'Transactionnel' or 'Analytique'
const initialData = [
    { id: 1, name: 'PostgreSQL', type: 'Transactionnel', openSource: true, hasAnimal: true, logo: 'databases/postgres.png', radius: 25 },
    { id: 2, name: 'Redis', type: 'Transactionnel', openSource: true, hasAnimal: false, logo: 'databases/redis.png', radius: 25 },
    { id: 3, name: 'MySQL', type: 'Transactionnel', openSource: true, hasAnimal: true, logo: 'databases/mysql.png', radius: 25 },
    { id: 4, name: 'Snowflake', type: 'Analytique', openSource: false, hasAnimal: false, logo: 'databases/snowflake.png', radius: 25 },
    { id: 5, name: 'Databend', type: 'Analytique', openSource: true, hasAnimal: true, logo: 'databases/databend.png', radius: 25 },
    { id: 6, name: 'SQL Server', type: 'Transactionnel', openSource: false, hasAnimal: false, logo: 'databases/microsoft-sql-server.png', radius: 25 },
    { id: 7, name: 'Mongo', type: 'Transactionnel', openSource: true, hasAnimal: false, logo: 'databases/mongo.png', radius: 25 },
    { id: 8, name: 'SQLite', type: 'Transactionnel', openSource: true, hasAnimal: false, logo: 'databases/sqlite.png', radius: 25 },
    { id: 9, name: 'Oracle', type: 'Transactionnel', openSource: false, hasAnimal: false, logo: 'databases/oracle.png', radius: 25 },
    { id: 10, name: 'MariaDB', type: 'Transactionnel', openSource: true, hasAnimal: true, logo: 'databases/mariadb.png', radius: 25 },
    { id: 11, name: 'Elasticsearch', type: 'Analytique', openSource: true, hasAnimal: false, logo: 'databases/elasticsearch.png', radius: 25 },
    { id: 12, name: 'DynamoDB', type: 'Transactionnel', openSource: false, hasAnimal: false, logo: 'databases/dynamodb.png', radius: 25 },
    { id: 13, name: 'Cassandra', type: 'Transactionnel', openSource: true, hasAnimal: false, logo: 'databases/cassandra.png', radius: 25 },
    { id: 14, name: 'Db2', type: 'Transactionnel', openSource: false, hasAnimal: false, logo: 'databases/db2.png', radius: 25 },
    { id: 15, name: 'BigQuery', type: 'Analytique', openSource: false, hasAnimal: false, logo: 'databases/bigquery.png', radius: 25 },
    { id: 16, name: 'InfluxDB', type: 'Analytique', openSource: true, hasAnimal: false, logo: 'databases/influxdb.png', radius: 25 },
    { id: 17, name: 'Access', type: 'Transactionnel', openSource: false, hasAnimal: false, logo: 'databases/access.png', radius: 25 },
    { id: 18, name: 'Memcached', type: 'Transactionnel', openSource: true, hasAnimal: false, logo: 'databases/memcached.png', radius: 25 },
    { id: 19, name: 'DuckDB', type: 'Analytique', openSource: true, hasAnimal: true, logo: 'databases/duckdb.png', radius: 25 },
    { id: 20, name: 'ClickHouse', type: 'Analytique', openSource: true, hasAnimal: false, logo: 'databases/clickhouse.png', radius: 25 },
    { id: 21, name: 'Druid', type: 'Analytique', openSource: true, hasAnimal: false, logo: 'databases/druid.png', radius: 25 },
    { id: 22, name: 'Pinecone', type: 'Analytique', openSource: false, hasAnimal: false, logo: 'databases/pinecone.png', radius: 25 },
    { id: 23, name: 'CockroachDB', type: 'Transactionnel', openSource: true, hasAnimal: true, logo: 'databases/cockroach.png', radius: 25 },
    { id: 24, name: 'Neo4j', type: 'Analytique', openSource: false, hasAnimal: false, logo: 'databases/neo4j.png', radius: 25 },
    { id: 25, name: 'SurrealDB', type: 'Analytique', openSource: true, hasAnimal: false, logo: 'databases/surreal.png', radius: 25 },
    { id: 26, name: 'TypeDB', type: 'Analytique', openSource: true, hasAnimal: false, logo: 'databases/typedb.png', radius: 25 },
    { id: 27, name: 'Teradata', type: 'Analytique', openSource: false, hasAnimal: false, logo: 'databases/teradata.png', radius: 25 },
    { id: 28, name: 'ArangoDB', type: 'Analytique', openSource: true, hasAnimal: false, logo: 'databases/arangodb.png', radius: 25 },
    { id: 29, name: 'Redshift', type: 'Analytique', openSource: false, hasAnimal: false, logo: 'databases/redshift.png', radius: 25 },
    { id: 30, name: 'SAP HANA', type: 'Analytique', openSource: false, hasAnimal: false, logo: 'databases/sap-hana.png', radius: 25 },
].map(d => ({
    ...d,
    x: width / 2 + (Math.random() - 0.5) * 100, // Start near center
    y: height / 2 + (Math.random() - 0.5) * 100
}));

const data = ref(initialData);

// Refs for the component
const chartContainer = ref(null);
const svgElement = ref(null);

// State for layout toggle
const groupingMode = ref('none'); // 'none', 'type', 'openSource', 'animal'
const showLabels = ref(false);
const isInitialized = ref(false);

// Configuration for groups
const groupCenters = computed(() => {
    // --- CHANGED ---
    // Move the center of the bubble clusters down to give labels more space
    const yPos = height / 2 + 50;

    if (groupingMode.value === 'type') {
        const types = Array.from(new Set(data.value.map(d => d.type))); // Will be ['Transactionnel', 'Analytique']
        const numGroups = types.length;
        const spacing = width / (numGroups + 1);
        return types.reduce((acc, type, i) => {
            acc[type] = { x: spacing * (i + 1), y: yPos }; // Use new yPos
            return acc;
        }, {});
    } else if (groupingMode.value === 'openSource') {
        return {
            'Open Source': { x: width / 3, y: yPos }, // Use new yPos
            'Propriétaire': { x: (2 * width) / 3, y: yPos } // Use new yPos
        };
    } else if (groupingMode.value === 'animal') {
        return {
            'Animal dans le logo': { x: width / 3, y: yPos }, // Use new yPos
            'Pas d\'animal': { x: (2 * width) / 3, y: yPos } // Use new yPos
        };
    }
    return {};
});

// --- MODIFIED COLOR SCALE ---
// Updated domain to match new types
const typeColorScale = d3.scaleOrdinal()
    .domain(['Transactionnel', 'Analytique'])
    .range(['#4c78a8aa', '#e45756aa']); // Blue for transactional, Red for analytical

const openSourceColorScale = d3.scaleOrdinal()
    .domain([true, false])
    .range(['#3c9a04aa', '#d32f2faa']); // Green for open source, Red for propriétaire

const animalColorScale = d3.scaleOrdinal()
    .domain([true, false])
    .range(['#ffc107aa', '#9e9e9eaa']); // Yellow for animal, Grey for no

let svg, simulation;

const drag = d3.drag()
    .on("start", (event, d) => {
        if (!event.active) simulation.alphaTarget(0.3).restart();
        d.fx = d.x;
        d.fy = d.y;
    })
    .on("drag", (event, d) => {
        d.fx = event.x;
        d.fy = event.y;
    })
    .on("end", (event, d) => {
        if (!event.active) simulation.alphaTarget(0);
        d.fx = null;
        d.fy = null;
    });

const getTargetPosition = (d) => {
    if (groupingMode.value === 'type') {
        return groupCenters.value[d.type];
    } else if (groupingMode.value === 'openSource') {
        return groupCenters.value[d.openSource ? 'Open Source' : 'Propriétaire'];
    } else if (groupingMode.value === 'animal') {
        return groupCenters.value[d.hasAnimal ? 'Animal dans le logo' : 'Pas d\'animal'];
    }
    return { x: width / 2, y: height / 2 };
};

const getCollisionRadius = (d) => {
    // When labels are shown (click === 1), increase spacing significantly
    if (showLabels.value) {
        return d.radius + 25; // Extra spacing for labels
    }
    return d.radius + 1.5; // Normal spacing
};

const getFillColor = (d) => {
    // Requirement 1: Bubbles are transparent for clicks <= 1
    if (context.$clicks.value <= 1) {
        return 'transparent';
    }

    switch (groupingMode.value) {
        case 'openSource':
            return openSourceColorScale(d.openSource);
        case 'animal':
            return animalColorScale(d.hasAnimal);
        case 'type':
            return typeColorScale(d.type);
        default:
            // Fallback to transparent if no group is active
            return 'transparent';
    }
};

const ticked = () => {
    svg.selectAll('.node-group')
        .attr('transform', d => `translate(${d.x}, ${d.y})`);

    svg.selectAll('.group-label:not(.exiting)')
        .attr('x', d => groupCenters.value[d]?.x || 0)
        // --- CHANGED ---
        // Set a fixed Y position near the top
        .attr('y', 40);
};

const updateNodes = () => {
    svg.selectAll('.node-group')
        .data(data.value, d => d.id)
        .join(
            enter => {
                const g = enter.append('g')
                    .attr('class', 'node-group')
                    .attr('transform', d => `translate(${d.x}, ${d.y})`)
                    .call(drag);

                g.append('circle')
                    .attr('r', d => d.radius)
                    .attr('fill', getFillColor) // Use dynamic color function
                    .attr('stroke', circleBorderColor.value)
                    .attr('stroke-width', 2);

                g.append('image')
                    .attr('xlink:href', d => d.logo)
                    .attr('width', d => d.radius * 1.5)
                    .attr('height', d => d.radius * 1.5)
                    .attr('x', d => -d.radius * 0.75)
                    .attr('y', d => -d.radius * 0.75);

                g.append('text')
                    .attr('text-anchor', 'middle')
                    .attr('dy', d => d.radius + 15)
                    .attr('class', 'bubble-label')
                    .attr('fill', textColor.value)
                    .style('text-shadow', `0 0 4px ${textShadowColor.value}`)
                    .attr('opacity', 0)
                    .text(d => d.name);

                return g;
            }
        );

    // Update labels opacity based on showLabels state
    svg.selectAll('.bubble-label')
        .attr('fill', textColor.value)
        .style('text-shadow', `0 0 4px ${textShadowColor.value}`)
        .transition().duration(500)
        .attr('opacity', showLabels.value ? 1 : 0);

    svg.selectAll('.node-group circle')
        .transition().duration(500)
        .attr('fill', getFillColor)
        .attr('stroke', circleBorderColor.value);

    let groupLabels = [];
    if (groupingMode.value === 'type') groupLabels = Array.from(new Set(data.value.map(d => d.type)));
    else if (groupingMode.value === 'openSource') groupLabels = ['Open Source', 'Propriétaire'];
    else if (groupingMode.value === 'animal') groupLabels = ['Animal dans le logo', 'Pas d\'animal'];

    svg.selectAll('.group-label')
        .data(groupLabels, d => d)
        .join(
            enter => enter.append('text')
                .attr('class', 'group-label')
                .attr('text-anchor', 'middle')
                .attr('font-size', '1.5em')
                .attr('font-weight', 'bold')
                .attr('fill', textColor.value)
                .style('text-shadow', `0 0 4px ${textShadowColor.value}`)
                .attr('opacity', 0)
                .text(d => d)
                .attr('x', d => groupCenters.value[d]?.x || width / 2)
                // --- CHANGED ---
                // Set a fixed Y position near the top
                .attr('y', 40),
            update => update
                .attr('fill', textColor.value)
                .style('text-shadow', `0 0 4px ${textShadowColor.value}`)
                .text(d => d),
            exit => exit.attr('class', 'group-label exiting')
                .transition().duration(300).attr('opacity', 0).remove()
        )
        .transition().duration(500)
        .attr('opacity', groupingMode.value !== 'none' ? 1 : 0);
};

// --- Lifecycle and Watchers ---

const { isDark } = useDarkMode()
const isActive = useIsSlideActive()
const context = useSlideContext()

const textColor = computed(() => isDark.value ? '#eee' : '#333');
const textShadowColor = computed(() => isDark.value ? '#333' : '#eee');
const circleBorderColor = computed(() => isDark.value ? '#eee' : '#333');

function updateStateForClicks(clicks) {
    showLabels.value = clicks === 1;

    if (clicks <= 1) {
        groupingMode.value = 'none';
    } else if (clicks === 2) {
        groupingMode.value = 'type';
    } else if (clicks === 3) {
        groupingMode.value = 'openSource';
    } else { // for clicks >= 4
        groupingMode.value = 'animal';
    }
}

function initializeSimulation() {
    if (!svgElement.value || svg) return;

    svg = d3.select(svgElement.value);
    simulation = d3.forceSimulation(data.value)
        .force('collide', d3.forceCollide().radius(getCollisionRadius).strength(0.8))
        .force('bound', () => {
            // Custom force to keep bubbles within viewport
            data.value.forEach(d => {
                const margin = d.radius + 5;
                d.x = Math.max(margin, Math.min(width - margin, d.x));
                d.y = Math.max(margin, Math.min(height - margin, d.y));
            });
        })
        .on('tick', ticked);

    // Set initial state based on current clicks
    updateStateForClicks(context.$clicks.value);

    // Configure forces based on initial grouping mode
    if (groupingMode.value !== 'none') {
        simulation
            .force('x', d3.forceX(d => getTargetPosition(d).x).strength(0.15))
            .force('y', d3.forceY(d => getTargetPosition(d).y).strength(0.15))
            .force('center', null);
    } else {
        simulation
            .force('x', d3.forceX(width / 2).strength(0.05))
            .force('y', d3.forceY(height / 2).strength(0.05))
            .force('center', d3.forceCenter(width / 2, height / 2));
    }

    updateNodes();

    if (groupingMode.value !== 'none') {
        // Stop ticking visually
        simulation.stop();

        // Run simulation to convergence
        for (let i = 0; i < 300; ++i) simulation.tick();

        // Update positions
        ticked();
        updateNodes();
    }

    isInitialized.value = true;
}

watch(isDark, () => {
    if (svg) {
        svg.selectAll('.bubble-label').attr('fill', textColor.value).style('text-shadow', `0 0 4px ${textShadowColor.value}`);
        svg.selectAll('.group-label').attr('fill', textColor.value).style('text-shadow', `0 0 4px ${textShadowColor.value}`);
        svg.selectAll('.node-group circle').attr('stroke', circleBorderColor.value);
    }
}, { flush: 'post' });

watch(isActive, (newVal) => {
    if (newVal) {
        nextTick(() => {
            initializeSimulation();
        });
    }
}, { immediate: true });

watch(groupingMode, (newVal) => {
    if (!simulation) return;
    simulation
        .force('x', d3.forceX(d => getTargetPosition(d).x).strength(newVal !== 'none' ? 0.15 : 0.05))
        .force('y', d3.forceY(d => getTargetPosition(d).y).strength(newVal !== 'none' ? 0.15 : 0.05))
        .force('center', newVal === 'none' ? d3.forceCenter(width / 2, height / 2) : null);
    simulation.alpha(1).restart();
    if (svg) updateNodes();
});

watch(showLabels, (newVal) => {
    if (svg) {
        updateNodes();
    }
    if (simulation) {
        // Update the collision force with new radius
        simulation.force('collide', d3.forceCollide().radius(getCollisionRadius).strength(0.8));
        simulation.alpha(0.3).restart(); // Gentle restart to adjust spacing
    }
});

watch(() => context.$clicks.value, (newVal) => {
    updateStateForClicks(newVal);
});
</script>

<style scoped>
.data-bubble-chart {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
}

.data-bubble-chart svg {
    overflow: visible;
}
</style>