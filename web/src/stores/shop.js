import { defineStore } from "pinia";
import Nui from '../nui'

export const useShopStore = defineStore('shop', {
    state: () => ({
        vehicles: [],
        categories: [
            'test'
        ],
        translation: {
            purchase: '',
            currency: ''
        },
    }),
    getters: {
        getVehicles: () => {
            return this.vehicles;
        },
        getCategories: () => {
            return this.categories;
        },
    },
    actions: {
        setVehicleList(vehicles) {
            this.vehicles = vehicles;
        },
        setCategoryList(categories) {
            this.categories = categories;
        },
        setTranslation(translation) {
            this.translation = translation;
        },
    }
})