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

// FIX: Initialize data with random starting positions to avoid the top-left corner bug.
// The simulation will now use these coordinates on the first render.
const initialData = [
    { id: 1, name: 'Postgres', type: 'Relational', openSource: true, hasAnimal: true, logo: '/databases/postgres.png', radius: 25 },
    { id: 2, name: 'Redis', type: 'In Memory', openSource: true, hasAnimal: false, logo: '/databases/redis.png', radius: 25 },
    { id: 3, name: 'MySQL', type: 'Relational', openSource: true, hasAnimal: true, logo: '/databases/mysql.png', radius: 25 },
    { id: 4, name: 'Snowflake', type: 'Hybrid', openSource: false, hasAnimal: false, logo: '/databases/snowflake.png', radius: 25 },
    { id: 5, name: 'Databend', type: 'Hybrid', openSource: true, hasAnimal: true, logo: '/databases/databend.png', radius: 25 },
    { id: 6, name: 'Microsoft SQL Server', type: 'Relational', openSource: false, hasAnimal: false, logo: '/databases/microsoft-sql-server.png', radius: 25 },
    { id: 7, name: 'Mongo', type: 'Hybrid', openSource: true, hasAnimal: false, logo: '/databases/mongo.png', radius: 25 },
    { id: 8, name: 'SQLite', type: 'Relational', openSource: true, hasAnimal: true, logo: '/databases/sqlite.png', radius: 25 },
    { id: 9, name: 'Oracle', type: 'Relational', openSource: false, hasAnimal: false, logo: '/databases/oracle.png', radius: 25 },
    { id: 10, name: 'MariaDB', type: 'Relational', openSource: true, hasAnimal: true, logo: '/databases/mariadb.png', radius: 25 },
    { id: 11, name: 'Elasticsearch', type: 'Hybrid', openSource: true, hasAnimal: false, logo: '/databases/elasticsearch.png', radius: 25 },
    { id: 12, name: 'DynamoDB', type: 'Hybrid', openSource: false, hasAnimal: false, logo: '/databases/dynamodb.png', radius: 25 },
    { id: 13, name: 'Cassandra', type: 'Hybrid', openSource: true, hasAnimal: false, logo: '/databases/cassandra.png', radius: 25 },
    { id: 14, name: 'Db2', type: 'Relational', openSource: false, hasAnimal: false, logo: '/databases/db2.png', radius: 25 },
    { id: 15, name: 'BigQuery', type: 'Hybrid', openSource: false, hasAnimal: false, logo: '/databases/bigquery.png', radius: 25 },
    { id: 16, name: 'InfluxDB', type: 'Time Series', openSource: true, hasAnimal: false, logo: '/databases/influxdb.png', radius: 25 },
    { id: 17, name: 'Access', type: 'Relational', openSource: false, hasAnimal: false, logo: '/databases/access.png', radius: 25 },
    { id: 18, name: 'Memcached', type: 'In Memory', openSource: true, hasAnimal: false, logo: '/databases/memcached.png', radius: 25 },
    { id: 19, name: 'DuckDB', type: 'Relational', openSource: true, hasAnimal: true, logo: '/databases/duckdb.png', radius: 25 },
    { id: 20, name: 'ClickHouse', type: 'Hybrid', openSource: true, hasAnimal: false, logo: '/databases/clickhouse.png', radius: 25 },
    { id: 21, name: 'Druid', type: 'Hybrid', openSource: true, hasAnimal: false, logo: '/databases/druid.png', radius: 25 },
    { id: 22, name: 'Pinecone', type: 'Vector', openSource: false, hasAnimal: false, logo: '/databases/pinecone.png', radius: 25 },
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

// Configuration for groups
const groupCenters = computed(() => {
    if (groupingMode.value === 'type') {
        const types = Array.from(new Set(data.value.map(d => d.type)));
        const numGroups = types.length;
        const spacing = width / (numGroups + 1);
        return types.reduce((acc, type, i) => {
            acc[type] = { x: spacing * (i + 1), y: height / 2 };
            return acc;
        }, {});
    } else if (groupingMode.value === 'openSource') {
        return {
            'Open Source': { x: width / 3, y: height / 2 },
            'Proprietary': { x: (2 * width) / 3, y: height / 2 }
        };
    } else if (groupingMode.value === 'animal') {
        return {
            'Animal dans le logo': { x: width / 3, y: height / 2 },
            'Pas cool': { x: (2 * width) / 3, y: height / 2 }
        };
    }
    return {};
});

// Create a color scale for types
const colorScale = d3.scaleOrdinal()
    .domain(['Relational', 'In Memory', 'Hybrid', 'Time Series', 'Vector'])
    .range(['#4c78a8aa', '#f58518aa', '#e45756aa', '#23a403aa', '#76b7b2aa']);

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
        return groupCenters.value[d.openSource ? 'Open Source' : 'Proprietary'];
    } else if (groupingMode.value === 'animal') {
        return groupCenters.value[d.hasAnimal ? 'Animal dans le logo' : 'Pas cool'];
    }
    return { x: width / 2, y: height / 2 };
};

const ticked = () => {
    svg.selectAll('.node-group')
        .attr('transform', d => `translate(${d.x}, ${d.y})`);

    svg.selectAll('.group-label:not(.exiting)')
        .attr('x', d => groupCenters.value[d]?.x || 0)
        .attr('y', d => (groupCenters.value[d]?.y - 100) || 0);
};

const updateNodes = () => {
    svg.selectAll('.node-group')
        .data(data.value, d => d.id)
        .join(
            enter => {
                const g = enter.append('g')
                    .attr('class', 'node-group')
                    .attr('transform', d => `translate(${d.x}, ${d.y})`) // Use initial positions
                    .call(drag);

                g.append('circle')
                    .attr('r', d => d.radius)
                    .attr('fill', d => colorScale(d.type))
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

    svg.selectAll('.bubble-label')
        .attr('fill', textColor.value)
        .style('text-shadow', `0 0 4px ${textShadowColor.value}`)
        .transition().duration(500)
        .attr('opacity', showLabels.value ? 1 : 0);

    svg.selectAll('.node-group circle')
        .attr('stroke', circleBorderColor.value);

    let groupLabels = [];
    if (groupingMode.value === 'type') groupLabels = Array.from(new Set(data.value.map(d => d.type)));
    else if (groupingMode.value === 'openSource') groupLabels = ['Open Source', 'Proprietary'];
    else if (groupingMode.value === 'animal') groupLabels = ['Animal dans le logo', 'Pas cool'];

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
                .attr('y', d => (groupCenters.value[d]?.y - 100) || height / 2),
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
    showLabels.value = clicks >= 1;

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

watch(isDark, () => {
    if (svg) {
        svg.selectAll('.bubble-label').attr('fill', textColor.value).style('text-shadow', `0 0 4px ${textShadowColor.value}`);
        svg.selectAll('.group-label').attr('fill', textColor.value).style('text-shadow', `0 0 4px ${textShadowColor.value}`);
        svg.selectAll('.node-group circle').attr('stroke', circleBorderColor.value);
    }
}, { flush: 'post' });


watch(isActive, (newVal) => {
    if (newVal && svgElement.value) {
        nextTick(() => {
            if (!svg) {
                svg = d3.select(svgElement.value);
                simulation = d3.forceSimulation(data.value)
                    .force('collide', d3.forceCollide().radius(d => d.radius + 1.5).strength(0.8))
                    .on('tick', ticked);
                updateNodes();
            }
            updateStateForClicks(context.$clicks.value);
        });
    }
}, { immediate: true });

watch(groupingMode, (newVal) => {
    if (!simulation) return;
    simulation
        .force('x', d3.forceX(d => getTargetPosition(d).x).strength(newVal !== 'none' ? 0.15 : 0.05))
        .force('y', d3.forceY(d => getTargetPosition(d).y).strength(newVal !== 'none' ? 0.15 : 0.05));
    simulation.alpha(1).restart();
    if (svg) updateNodes();
});

watch(showLabels, () => {
    if (svg) updateNodes();
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