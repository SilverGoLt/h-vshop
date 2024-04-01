<script lang="ts">
import { useShopStore } from './store/shop';
import Categories from './components/Categories.vue';
import Vehicles from './components/Vehicle.vue';
import Selected from './components/Selected.vue';
import Timer from './components/timer.vue';
import Nui from './nui'
import MouseIcon from './assets/mouse.svg'

export default {
  name: 'Vehicle Shop',
  components: {
    Categories,
    Vehicles,
    Selected,
    Timer
  },
  emits: ['startTimer'],
  data() {
    return {
      display: false,
      loading: false,
      holding: false,
      oldx: 0,
      mouseDirection: '',
      timer: {
        show: false,
        time: 0,
      },
      mouseIcon: MouseIcon
    }
  },
  mounted() {
    window.addEventListener('message', (event) => {
      let data = event.data
      switch (data.type) {
        case 'open':
          this.display = true;
          console.log(JSON.stringify(data, null, 2))
          const category = data.shop.category;
          if (category instanceof Array) { category.push('clear'); }
          this.shopStore.setStore({ name: data.shop.name, description: data.shop.description });
          this.shopStore.setCategories(category);
          this.shopStore.setTranslation(data.translation);
          this.shopStore.setVehicles(data.cars);
          break;
        case 'loadingDone':
          this.shopStore.loading = false;
          break;
        case 'startTimer':
          this.timer.show = true;
          this.timer.time = data.time;
          break;
        case 'stopTimer':
          this.timer.show = false;
          break;
        case 'close':
          this.display = false;
          break;
      }
    })
  },
  created() {
    let that = this;
    document.addEventListener('mousemove', that.NUIMouseMove)
    document.addEventListener('mousedown', () => that.holding = true)
    document.addEventListener('mouseup', () => that.holding = false)
    document.addEventListener('keyup', function (evt) {
      if (evt.keyCode === 27) {
        that.close();
      }
    });
  },
  methods: {
    NUIMouseMove(e: any) {
      if (e.pageX < this.oldx) { this.mouseDirection = 'left' } else { this.mouseDirection = 'right' }
      this.oldx = e.pageX
      if (this.mouseDirection == "left" && this.holding) {
        if (e.target.classList.contains("main-shop")) {
          Nui('rotateVeh', { type: 'right' })
        }
      }
      if (this.mouseDirection == "right" && this.holding) {
        if (e.target.classList.contains("main-shop")) {
          Nui('rotateVeh', { type: 'left' })
        }
      }
    }, close() {
      this.display = false
      this.shopStore.resetData()
      Nui('closeShop');
    },
    startTest() {
      console.log('test drive')
      Nui('testDrive', { vehicle: this.shopStore.currentVehicle.model }).then((bool: boolean) => {
        if (bool) {
          this.close()
        }
      })
    }
  },
  setup() {
    const shopStore = useShopStore()

    return {
      shopStore
    }
  }
}
</script>

<template>
  <div v-show="display"
    class="flex flex-col items-end justify-start w-full h-screen p-8 space-y-5 text-white main-shop bg-gradient-to-l from-black via-transparent to-transparent">
    <div v-motion-pop class="main-stuff w-[380px] p-4 flex flex-col space-y-6 relative items-start overflow-hidden">
      <div class="flex flex-row items-center space-x-3 exit-shop absolue left-12">
        <div class="flex flex-row items-center space-x-3 rotate escape">
          <div class="px-2 rounded-lg button bg-white/20">ESC</div>
          <span class="text-sm">Exit Shop</span>
        </div>
        <div class="flex flex-row items-center space-x-3 rotate">
          <div class="px-2 py-2 rounded-lg icon bg-white/20">
            <img :src="mouseIcon" class="h-[24px] left-[2px] relative" alt="" srcset="">
          </div>
          <span class="text-sm">Rotate Vehicle</span>
        </div>
      </div>
      <div class="top">
        <div class="text-3xl font-medium title font-Dancing">
          <span class="">{{ shopStore.store.name }}</span>
        </div>
        <div class="description">
          <p class="text-sm text-white/50">{{ shopStore.store.description }}</p>
        </div>
        <div class="categories">
          <Categories />
        </div>
      </div>
      <Vehicles />
      <Selected @startTimer="startTest" />
    </div>
  </div>
  <Timer v-if="timer.show" :time="timer.time" />
</template>

<style>
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
</style>
