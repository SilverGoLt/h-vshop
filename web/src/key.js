export default {
    created() {
        let that = this;

        document.addEventListener('keyup', function (evt) {
            if (evt.keyCode === 27) {
                that.close();
            }
        });
    },
};