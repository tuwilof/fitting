<template>
  <div>
    Action page
    <p>{{this.$route.query.prefix}}</p>
    <p>{{this.$route.query.method}} {{this.$route.query.path}}</p>
    {{myJson['prefixes_details']}}
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