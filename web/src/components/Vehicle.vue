<script lang="ts">
import { useShopStore } from '../store/shop';

export default {
    name: 'Vehicle List',
    setup() {
        const shopStore = useShopStore()

        return {
            shopStore
        }
    },
    methods: {
        numberWithCommas(x: Number) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
    }
}
</script>

<template>
    <div class="flex flex-col w-full pr-3 space-y-3 overflow-y-scroll h-2/3 vehicles">
        <div v-for="car, key in shopStore.getFilteredVehicles" :key="key"
            v-if="!shopStore.loading"
            @click="shopStore.setCurrentVehicle(car)"
            :class="[shopStore.currentVehicle.name === car.name ? 'bg-opacity-50' : 'bg-opacity-10']"
            class="flex flex-row items-center justify-between h-24 px-8 py-4 transition-all ease-in-out bg-white rounded-lg cursor-pointer vehicle bg-opacity-10 hover:bg-opacity-30">
            <div class=" left">
                <div class="text-lg name">
                    <span>{{ car.name }}</span>
                </div>
                <div class="mt-2 text-xs uppercase">
                    <span class="px-2 rounded-lg bg-white/10">{{ car.category }}</span>
                </div>
            </div>
            <div class="right">
                <div class="text-green-400 price">
                    <span class="text-lg">{{ shopStore.translation.currency }}{{ numberWithCommas(car.price) }}</span>
                </div>
            </div>
        </div>
    </div>
</template>
