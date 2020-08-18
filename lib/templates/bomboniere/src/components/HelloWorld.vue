<template>
  <div id="main">
    <div v-if="myJson.tests_without_prefixes.length != 0">
      <div class="accordion-item">
        <div class="tests_without_prefixes accordion-item-head" v-on:click="accordion">
          tests without prefixes: {{ myJson.tests_without_prefixes.length }} ✖
        </div>
        <div class="accordion-item-body">
          <div v-for="test_without_prefixes in myJson.tests_without_prefixes">
            <div class="test_without_prefixes">{{ test_without_prefixes }} ✖</div>
          </div>
        </div>
      </div>
    </div>

    <div v-for="prefix_details in myJson.prefixes_details">

      <div>
        <div class="accordion-item">

          <div class="prefix accordion-item-head active" v-on:click="accordion">
            {{ prefix_details.name }}
          </div>

          <div class="accordion-item-body">

            <div v-if="prefix_details.actions.tests_without_actions.length != 0">
              <div class="accordion-item">
                <div class="tests_without_actions accordion-item-head" v-on:click="accordion">
                  tests without actions: {{ prefix_details.actions.tests_without_actions.length }} ✖
                </div>
                <div class="accordion-item-body">
                  <div v-for="test_without_actions in prefix_details.actions.tests_without_actions">
                    <div class="test_without_actions">{{ test_without_actions }} ✖</div>
                  </div>
                </div>
              </div>
            </div>

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
      myJson: {'stub': 'prefixes report'}
    }
  },
  methods: {
    accordion: function (event) {
      event.target.classList.toggle('active');
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

.tests_without_prefixes:hover {
  background-color: #2b2b2b;
}

.test_without_prefixes {
  background-color: #273645;
  color: #b94283;
  margin: 2px 0px 0px 16px;
  height: 20px;
  text-align: left;
  padding: 0px 8px;
}

.tests_without_actions {
  background-color: #273645;
  color: #b94283;
  margin: 2px 0px 0px 16px;
  padding: 0px 8px;
  height: 20px;
  text-align: left;
}

.tests_without_actions:hover {
  background-color: #2b2b2b;
}

.test_without_actions {
  background-color: #273645;
  color: #b94283;
  margin: 2px 0px 0px 24px;
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
