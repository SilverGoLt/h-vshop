import {defineStore} from 'pinia'
import { IStore } from '../interfaces/IStore'
import { IVehicle } from '../interfaces/IVehicle'
import { ITranslation } from '../interfaces/ITranslation'
import Callback from '../nui'

export const useShopStore = defineStore({
    id: 'shop',
    state: () => ({
        store: {
            name: 'Premium Dealership Motors',
            description: 'At our dealership you can find only premium quality vehicles that are brand new and not used!'
        } as IStore,
        vehicles: [] as IVehicle[],
        translation: {
            purchase: 'Purchase',
            currency: '$',
        } as ITranslation,
        categories: [
            'clear',
        ] as string[],
        currentVehicle: {} as IVehicle,
        currentCategory: 'clear',
        loading: false,
    }),
    getters: {
        getStore: (state) => state.store,
        getVehicles: (state) => state.vehicles,
        getTranslation: (state) => state.translation,
        getFilteredVehicles: (state) => {
            if (state.currentCategory === 'clear') {
                return state.vehicles
            }
            return state.vehicles.filter((vehicle) => vehicle.category === state.currentCategory)
        }
    },
    actions: {
        setStore(store: IStore) {
            this.store = store
        },
        setVehicles(vehicles: IVehicle[]) {
            this.vehicles = vehicles
        },
        setCurrentVehicle(vehicle: IVehicle) {
            this.currentVehicle = vehicle
            this.loading = true
            Callback('selectCar', {vehicle: vehicle.model})
        },
        setTranslation(translation: ITranslation) {
            this.translation = translation
        },
        setCategories(categories: string[]) {
            this.categories = categories
        },
        setCategory(category: string) {
            this.currentCategory = category
        },
        resetData() {
            this.store = { name: '', description: '' }
            this.vehicles = []
            this.translation = { purchase: '', currency: '', exit: '' }
            this.currentCategory = 'clear'
            // @ts-ignore
            this.currentVehicle = {}
            this.categories = []
        }
    }
})