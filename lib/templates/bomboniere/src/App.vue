<template>
  <div id="app">
    <div id="nav">
      <router-link to="/">Prefixes</router-link> |
      <router-link to="/about">About</router-link>
    </div>
    <router-view/>
  </div>
</template>

<style>
body {
  background-color: #2c3e50;
}

h1,h2,h3,h4,h5,h6,p {
  color: #42b983;
}

.pink {
  color: #b94283
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #42b983;
}

#nav a.router-link-exact-active {
  color: #42b983;
}

#main {
  font-size: 10pt;
}

.prefix {
  background-color: #273645;
  color: #42b983;
  margin: 2px 0px;
  padding: 0px 8px;
  height: 20px;
}

.prefix-name {
  width: 300px;
  float: left;
  text-align: left;
}

.action {
  background-color: #273645;
  color: #42b983;
  margin: 2px 16px;
  height: 20px;
}

.method {
  width: 100px;
  float: left;
  padding: 0px 8px;
  text-align: left;
}

.path {
  width: 400px;
  float: left;
  text-align: left;
}
</style>
