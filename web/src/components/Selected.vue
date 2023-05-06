<script lang="ts">
import postData from '../nui'
import { useShopStore } from '../store/shop';   

export default {
    name: 'Selected Vehicle',
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
        purhcase() {
            postData('purchase', {vehicle: this.shopStore.currentVehicle.model}).then((bool: boolean) =>{
                if (bool) {
                    postData('closeShop')
                }
            })
        }
    }
}
</script>

<template>
    <div v-if="Object.keys(shopStore.currentVehicle).length > 0" class="flex flex-col items-center w-full space-y-3 purchase">
        <div class="text-white price">
            <span class="text-2xl font-medium">{{ shopStore.translation.currency }}{{ numberWithCommas(shopStore.currentVehicle.price) }}</span>
        </div>
        <div @click="purhcase"
            class="px-8 py-2 text-white transition-all ease-in-out transform bg-green-500 rounded-lg cursor-pointer purchase-btn hover:scale-105 hover:bg-green-600">
            <span> {{ shopStore.translation.purchase }} </span>
        </div>
        <div @click="$emit('startTimer')"
            class="px-4 py-1 text-sm text-white transition-all ease-in-out transform bg-yellow-500 rounded-lg cursor-pointer purchase-btn hover:scale-105 hover:bg-yellow-600">
            <span>Test Drive</span>
        </div>
    </div>
</template>