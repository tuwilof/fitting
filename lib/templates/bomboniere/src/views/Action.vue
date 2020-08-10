<template>
  <div>
    Action page
    <p>{{this.$route.query.prefix}}</p>
    <p>{{this.$route.query.method}} {{this.$route.query.path}}</p>
  </div>
</template>