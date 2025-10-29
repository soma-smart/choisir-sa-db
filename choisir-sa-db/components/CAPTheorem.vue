<script setup>
import { ref, onMounted, watch } from 'vue'
import * as d3 from 'd3'

const width = 400
const height = 400
const radius = 70
const cx = width / 2
const cy = height / 2.5

// Updated Data for the three main circles with brighter colors
const circlesData = [
    // Lighter, more vibrant colors for better contrast in dark mode with mix-blend-mode: multiply
    { id: 'C', label: 'Consistency', x: cx - radius / 1.3, y: cy - radius / 2, color: '#FFD700', click: 1 }, // Gold
    { id: 'A', label: 'Availability', x: cx + radius / 1.3, y: cy - radius / 2, color: '#87CEEB', click: 2 }, // SkyBlue
    { id: 'P', label: 'Partition Tolerance', x: cx, y: cy + radius / 1.1, color: '#90EE90', click: 3 }, // LightGreen
]

const labelsData = [
    { id: 'C-title', text: 'Consistency', x: circlesData[0].x, y: circlesData[0].y - radius - 20, click: 1, type: 'title' },
    { id: 'A-title', text: 'Availability', x: circlesData[1].x, y: circlesData[1].y - radius - 20, click: 2, type: 'title' },
    { id: 'P-title', text: 'Partition Tolerance', x: circlesData[2].x, y: circlesData[2].y + radius + 30, click: 3, type: 'title' },

    { id: 'CA-label', text: 'CA', x: cx, y: cy - radius / 2.5, click: 2, type: 'intersection' },
    { id: 'CP-label', text: 'CP', x: cx - radius / 2.2, y: cy + radius / 3.5, click: 3, type: 'intersection' },
    { id: 'AP-label', text: 'AP', x: cx + radius / 2.2, y: cy + radius / 3.5, click: 3, type: 'intersection' },
]

const svgRef = ref(null)

const updateStateForClicks = (count) => {
    if (!svgRef.value) return

    const svg = d3.select(svgRef.value)
    const t = d3.transition().duration(400)

    svg.selectAll('.cap-circle')
        .data(circlesData, d => d.id)
        .transition(t)
        .style('opacity', d => (count >= d.click ? 0.6 : 0))

    svg.selectAll('.cap-label')
        .data(labelsData, d => d.id)
        .transition(t)
        .style('opacity', d => (count >= d.click ? 1 : 0))
}

onMounted(() => {
    const svg = d3.select(svgRef.value)
        .attr('width', '100%')
        .attr('height', '100%')
        .attr('viewBox', `0 0 ${width} ${height}`)
        .style('overflow', 'visible')

    svg.selectAll('.cap-circle')
        .data(circlesData, d => d.id)
        .enter()
        .append('circle')
        .attr('class', 'cap-circle')
        .attr('id', d => d.id)
        .attr('cx', d => d.x)
        .attr('cy', d => d.y)
        .attr('r', radius)
        .style('fill', d => d.color)
        .style('mix-blend-mode', 'plus-darker')
        .style('opacity', 0)

    svg.selectAll('.cap-label')
        .data(labelsData, d => d.id)
        .enter()
        .append('text')
        .attr('class', 'cap-label')
        .attr('x', d => d.x)
        .attr('y', d => d.y)
        .attr('text-anchor', 'middle')
        .attr('dominant-baseline', 'middle')
        .attr('fill', 'currentColor')
        .style('font-size', d => d.type === 'intersection' ? '24px' : '18px')
        .style('font-weight', d => d.type === 'intersection' ? 'bold' : 'normal')
        .text(d => d.text)
        .style('opacity', 0)

    updateStateForClicks($slidev.nav.clicks)

    watch(() => $slidev.nav.clicks, (newVal) => {
        updateStateForClicks(newVal)
    })
})
</script>

<template>
    <div class="cap-diagram-container">
        <svg ref="svgRef"></svg>
    </div>
</template>

<style scoped>
.cap-diagram-container {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
}

.cap-label {
    fill: var(--slidev-theme-color-text, #333);
}
</style>