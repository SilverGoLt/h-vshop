<script lang="ts">
import { useShopStore } from '../store/shop'

export default {
    name: 'Vehicle Categories',
    setup() {
        const shopStore = useShopStore()

        return {
            shopStore
        }
    },
    methods: {
        setCategory(category: string) {
            this.shopStore.setCategory(category)
        }
    }
}
</script>

<template>
    <div v-if="shopStore.categories instanceof Array" class="mt-3 category">
        <div class="flex flex-row flex-wrap items-center space-x-1">
            <div @click="setCategory(category)" v-for="category in shopStore.categories" :key="category"
                :class="[ shopStore.currentCategory === category ? 'bg-opacity-100 text-black' : 'bg-opacity-10 text-white']"
                class="px-2 py-1 mt-1 text-xs font-medium uppercase transition-all ease-in-out bg-white rounded-full cursor-pointer bg-opacity-10 hover:text-white hover:bg-opacity-20 category">
                <span>{{ category }}</span>
            </div>
        </div>
    </div>
</template>