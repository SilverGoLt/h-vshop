<script>
import Nui from '../nui'

export default {
    name: "Timer",
    props: {
        time: {
            type: Number,
            default: 0
        }
    },
    data() {
        return {
            interval: null,
            currentTime: this.time
        };
    },
    created() {
        this.interval = setInterval(() => {
            if(this.currentTime !== 0) {
                this.currentTime -= 1;
            } else {
                Nui('stopTestDrive', {});
                clearInterval(this.interval);
            }
        }, 1000);
    },
};
</script>

<template>
    <div class="absolute z-50 flex items-start justify-center w-full text-xl italic text-white uppercase font-Saira top-8 overflow-none timer-container">
        <span>{{currentTime}}s</span>
    </div>
</template>