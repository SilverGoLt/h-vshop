<template>
  <Transition name="fade">
    <div class="content">
      <Timer v-if="timer.show" :time="timer.time" />
      <div v-show="display"
        class="flex items-center justify-between w-full h-screen p-8 bg-gradient-to-l from-black via-transparent to-transparent font-Saira main">
        <div class="flex flex-col space-y-5 p-4 h-full w-[380px] left">
        </div>
        <div class="right relative flex flex-col space-y-5 p-4 h-full w-[380px]">
          <div @click="close"
            class="absolute text-white uppercase transition-all cursor-pointer hover:text-gray-400 top-20 exit -left-20">
            <span>exit</span>
          </div>
          <div class="top">
            <div class="text-3xl font-medium text-white font-Dancing header">
              <span>{{store.name}}</span>
            </div>
            <div class="text-sm text-white description">
              <p>{{store.description}}</p>
            </div>
            <div v-if="shopStore.categories instanceof Array" class="mt-3 category">
              <div class="flex flex-row flex-wrap items-center space-x-1">
                <div @click="setCategory(category)" v-for="category in shopStore.categories" :key="category"
                  class="px-2 py-1 mt-1 text-xs font-medium text-white uppercase transition-all ease-in-out bg-white rounded-full cursor-pointer bg-opacity-10 hover:bg-opacity-20 category">
                  <span>{{ category }}</span>
                </div>
              </div>
            </div>
          </div>
          <div v-if="loading"
            class="relative z-20 flex flex-col space-y-5 items-center justify-center w-[380px] h-screen loading">
            <div class="flex flex-row space-x-3 dots">
              <div class="w-4 h-4 bg-white rounded-full animate-bounce dot-one">
              </div>
              <div class="w-4 h-4 bg-white rounded-full animate-bounce dot-two">
              </div>
              <div class="w-4 h-4 bg-white rounded-full animate-bounce dot-three">
              </div>
            </div>
            <span class="text-white animate-pulse">Spawning Vehicle</span>
          </div>
          <Transition>
            <div v-if="selected && !loading" class="flex flex-col items-center w-full space-y-3 purchase">
              <div class="text-white price">
                <span class="text-2xl font-medium">{{ translation.currency }}{{ numberWithCommas(price) }}</span>
              </div>
              <div @click="purchase"
                class="px-8 py-2 text-white transition-all ease-in-out transform bg-green-500 rounded-lg cursor-pointer purchase-btn hover:scale-105 hover:bg-green-600">
                <span> {{ shopStore.translation.purchase }} </span>
              </div>
              <div @click="testDrive"
                class="px-4 py-1 text-sm text-white transition-all ease-in-out transform bg-yellow-500 rounded-lg cursor-pointer purchase-btn hover:scale-105 hover:bg-yellow-600">
                <span>Test Drive</span>
              </div>
            </div>
          </Transition>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script>
import Nui from './nui'
import { useShopStore } from './stores/shop'
import Timer from './components/timer.vue'

export default {
  name: 'Vehicle Shop Screen',
  components: {
    Timer
  },
  setup() {
    const shopStore = useShopStore()

    return {
      shopStore
    }
  },
  data() {
    return {
      selected: false,
      display: true,
      loading: false,
      model: '',
      selectedCategory: 'clear',
      price: 0,
      store: {
        name: 'Harokio Kampine',
        description: 'Stumdom belekokias masinites',
      },
      timer: {
        show: false,
        time: 0,
      }
    }
  },
  methods: {
    numberWithCommas(x) {
      return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    },
    close() {
      this.selected = false;
      this.display = false;
      Nui('closeShop');
    },
    purchase() {
      Nui('purchase', { vehicle: this.model }).then(data => {
        if (data) {
          this.close();
        }
      });
    },
    testDrive() {
      Nui('testDrive', { vehicle: this.model }).then(data => {
        if (data) {
          this.close();
        }
      });
    },
    setCategory(category) {
      this.selectedCategory = category;
    }
  },
  mounted() {
    window.addEventListener('message', (event) => {
      const data = event.data
      switch (data.type) {
        case 'open':
          this.display = true;
          this.store = data.shop;
          // Category Setter and Translation (Store)
          const category = data.shop.category;
          category.push('clear');
          this.shopStore.setCategoryList(category);
          this.shopStore.setTranslation(data.translation);
          break;
        case 'loadingDone':
          this.loading = false;
          break;
        case 'startTimer':
          this.timer.show = true;
          this.timer.time = data.time;
          break;
        case 'stopTimer':
          this.timer.show = false;
          break;
      }
    })
  },
  computed: {
    filterVehicles() {
      if (this.selectedCategory !== 'clear') {
        return this.vehicles.filter(vehicle => vehicle.category === this.selectedCategory);
      } else {
        return this.vehicles;
      }
    }
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

.dot-two {
  animation-delay: 0.2s;
}

.dot-three {
  animation-delay: 0.3s;
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
