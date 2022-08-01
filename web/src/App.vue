<template>
  <Transition name="fade">
  <div v-show="display" class="flex items-center justify-between w-full h-screen p-8 bg-gradient-to-l from-black via-transparent to-transparent font-Saira main">
    <div class="flex flex-col space-y-5 p-4 h-full w-[380px] left">
    </div>
    <div class="right relative flex flex-col space-y-5 p-4 h-full w-[380px]">
      <div @click="close" class="absolute text-white uppercase transition-all cursor-pointer hover:text-gray-400 top-20 exit -left-20">
        <span>exit</span>
      </div>
      <div class="top">
        <div class="text-3xl font-medium text-white font-Dancing header">
          <span>{{store.name}}</span>
        </div>
        <div class="text-sm text-white description">
          <p>{{store.description}}</p>
        </div>
      </div>
      <div class="flex flex-col w-full pr-3 space-y-3 overflow-y-scroll h-2/3 vehicles">
        <div @click="selectVehicle(car)" v-for="car, key in vehicles" :key="key"
          class="flex flex-row items-center justify-between h-24 px-8 py-4 transition-all ease-in-out bg-white rounded-lg cursor-pointer vehicle bg-opacity-10 hover:bg-opacity-30">
          <div class=" left">
            <div class="text-lg text-white name">
              <span>{{ car.name }}</span>
            </div>
            <div class="text-sm text-white uppercase category">
              <span>{{ car.category }}</span>
            </div>
          </div>
          <div class="right">
            <div class="text-green-400 price">
              <span class="text-lg">{{ translation.currency }}{{ numberWithCommas(car.price) }}</span>
            </div>
          </div>
        </div>
      </div>
      <Transition>
        <div v-if="selected" class="flex flex-col items-center w-full space-y-3 purchase">
          <div class="text-white price">
            <span class="text-2xl font-medium">{{ translation.currency }}{{ numberWithCommas(price) }}</span>
          </div>
          <div @click="purchase"
            class="px-8 py-2 text-white transition-all ease-in-out transform bg-green-500 rounded-lg cursor-pointer purchase-btn hover:scale-105 hover:bg-green-600">
            <span>{{ translation.purchase }}</span>
          </div>
        </div>
      </Transition>
    </div>
  </div>
  </Transition>
</template>

<script>
import Nui from './nui'

export default {
  name: 'Vehicle Shop Screen',
  data() {
    return {
      selected: false,
      display: false,
      model: '',
      price: 0,
      store: {
        name: '',
        description: ''
      },
      vehicles: [
      ],
      translation: {
        purchase: '',
        currency: ''
      }
    }
  },
  methods: {
    selectVehicle(car) {
      this.selected = true;
      this.model = car.model;
      this.price = car.price;
      Nui('selectCar', {vehicle: car.model});
    },
    numberWithCommas(x) {
      return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    },
    close(){
      this.selected = false;
      this.display = false;
      Nui('closeShop');
    },
    purchase(){
      Nui('purchase', {vehicle: this.model}).then(data => {
        if(data) {
          this.close();
        }
      });
    }
  },
  mounted() {
    window.addEventListener('message', (event) => {
      const data = event.data
      switch(data.type) {
        case 'open':
          this.display = true;
          this.store = data.shop;
          this.vehicles = data.cars;
          this.translation.purchase = data.translation.purchase;
          this.translation.currency = data.translation.currency;
          break;
      }
    })
  }
}
</script>

<style>
@tailwind base;
@tailwind components;
@tailwind utilities;

#app {
  overflow: hidden;
}

/* width */
::-webkit-scrollbar {
  width: 5px;
}

/* Track */
::-webkit-scrollbar-track {
  background: #f1f1f159;
}

/* Handle */
::-webkit-scrollbar-thumb {
  background: rgb(255, 255, 255);
}

/* Transitions */
.v-enter-active,
.v-leave-active {
  transition: all 0.5s ease;
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

.fade-enter-active,
.fade-leave-active {
  transition: all 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateX(500px);
}
</style>
