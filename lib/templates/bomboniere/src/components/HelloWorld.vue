<template>
  <div id="main">
    <div class="tests_without_prefixes">tests without prefixes: {{ myJson.tests_without_prefixes.length}} ✖</div>
    <div v-for="test_without_prefixes in myJson.tests_without_prefixes">
      <div class="test_without_prefixes">{{ test_without_prefixes }} ✖</div>
    </div>
    <div v-for="prefix_details in myJson.prefixes_details">
      <div class="prefix">{{ prefix_details.name }}</div>
      <div v-for="action_details in prefix_details.actions.actions_details">
        <div class="action">
          <router-link
              :to="{ path: 'action', query: { prefix: prefix_details.name, method: action_details.method, path: action_details.path }}">
            <div class="method">{{ action_details.method }}</div>
            <div class="path">{{ action_details.path }}</div>
            <div v-for="responses_details in action_details.responses.responses_details">
              <div class="responses_details">{{ responses_details.combinations.combinations_cover_percent }}
                {{ responses_details.method }}
              </div>
            </div>
          </router-link>
        </div>
      </div>

      <div v-for="test_without_actions in prefix_details.actions.tests_without_actions">
        <h4>{{ test_without_actions }} ✖</h4>
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

.tests_without_prefixes {
  background-color: #273645;
  color: #b94283;
  margin: 2px 0px;
  padding: 0px 8px;
  height: 20px;
  text-align: left;
}

.test_without_prefixes {
  background-color: #273645;
  color: #b94283;
  margin: 2px 0px 0px 16px;
  height: 20px;
  text-align: left;
  padding: 0px 8px;
}

.responses_details {
    float: left;
    text-align: left;
    padding: 0px 2px;
}

.action:hover {
  background-color: #2b2b2b;
}

.response {
    width: 50px;
    float: left;
    text-align: left;
}

.error {
    color: red;
    width: 10px;
    float: left;
    text-align: left;
}

a:link {
    color: #42b983;
    text-decoration: none;
}

a:visited {
    color: #42b983;
    text-decoration: none;
}

a:hover {
    color: #42b983;
    text-decoration: none;
}

a:active {
    color: #42b983;
    text-decoration: none;
}
</style>
