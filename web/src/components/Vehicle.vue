<template>
    <div class="flex flex-col w-full pr-3 space-y-3 overflow-y-scroll h-2/3 vehicles">
        <div v-for="car, key in filterVehicles" :key="key"
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
</template>