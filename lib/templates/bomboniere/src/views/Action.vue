<template>
  <div>
    Action page
    <p>{{this.$route.query.prefix}}</p>
    <p>{{this.$route.query.method}} {{this.$route.query.path}}</p>
    <div v-for="data in myJson['prefixes_details']">
      <div v-if="$route.query.prefix == data['name']" class="accordion-item">
        <div v-for="action in data['actions']['actions_details']">
          <div v-if="$route.query.method == action['method'] && $route.query.path == action['path']" class="accordion-item">
            <div class="action">{{action}}</div>
          </div>
        </div>
      </div>
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
      myJson: {'stub': 'for action page'}
    }
  }
}
</script>

<style>
.action {
  color: #42b983;
}
</style>