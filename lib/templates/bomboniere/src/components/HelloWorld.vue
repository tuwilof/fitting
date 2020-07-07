<template>
  <div>
      <h3>prefixes_details ✔</h3>
      <div v-for="prefix_details in myJson['prefixes_details']">
          <p>{{prefix_details['name']}} {{prefix_details['tests_size']}} ✔</p>
      </div>

      <h3 class="pink">tests_without_prefixes ✖</h3>
      <div v-for="test_without_prefixes in myJson['tests_without_prefixes']">
          <p class="pink">{{test_without_prefixes}} ✖</p>
      </div>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
      myJson: {'stub': 'prefixes report'}
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
