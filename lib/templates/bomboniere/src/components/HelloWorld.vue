<template>
  <div>
      <div v-for="prefix_details in myJson['prefixes_details']">
          <h2>{{prefix_details['name']}} {{prefix_details['tests_size']}} ✔</h2>
          <div v-for="action_details in prefix_details['actions']['actions_details']">
              <h4>{{action_details['method']}} {{action_details['path']}} {{action_details['tests_size']}} ✔</h4>
          </div>

          <div v-for="test_without_actions in prefix_details['actions']['tests_without_actions']">
              <h4>{{test_without_actions}} ✖</h4>
          </div>
      </div>

      <div v-for="test_without_prefixes in myJson['tests_without_prefixes']">
          <h2 class="pink">{{test_without_prefixes}} ✖</h2>
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
