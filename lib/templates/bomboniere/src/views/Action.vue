<template>
  <div id="main">
    <div v-for="prefix in myJson.prefixes_details">
      <div v-if="$route.query.prefix == prefix.name" class="accordion-item">
        <div class="prefix">{{prefix.name}}</div>
        <div v-for="action in prefix.actions.actions_details">
          <div v-if="$route.query.method == action.method && $route.query.path == action.path" class="accordion-item">
            <div class="action">
              <div class="method">{{action.method}}</div>
              <div class="path">{{action.path}}</div>
            </div>

            <div v-if="action.responses.tests_without_responses.length != 0">
              <div class="accordion-item">
                <div class="tests_without_responses accordion-item-head" v-on:click="accordion">
                  tests without responses: {{ action.responses.tests_without_responses.length }} ✖
                </div>
                <div class="accordion-item-body">
                  <div v-for="test_without_responses in action.responses.tests_without_responses">
                    <div class="test_without_responses">
                      {{ test_without_responses }} ✖
                      {{tests[test_without_responses]}}
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div v-for="response in action.responses.responses_details">
              <div class="response">
                <div class="accordion-item">
                  <div class="accordion-item-head" v-on:click="accordion">
                    <div v-if="response.combinations.cover_percent == '100%'" class="response_good">
                      {{ response.combinations.cover_percent }}
                      {{ response.method }}
                    </div>
                    <div v-else class="response_bad">
                      {{ response.combinations.cover_percent }}
                      {{ response.method }}
                    </div>
                  </div>
                  <div class="accordion-item-body">
                    <vue-json-compare :oldData="jsonSchemas[response.json_schema]"
                                      :newData="jsonSchemas[response.json_schema]"></vue-json-compare>
                  </div>
                </div>
              </div>
              <div v-for="combination in response.combinations.combinations_details">
                <div class="combination">
                  <div class="accordion-item">
                    <div class="accordion-item-head" v-on:click="accordion">
                      type: {{ combination.type }}, name: {{ combination.name }}, tests_size:
                      {{ combination.tests_size }}
                    </div>
                    <div class="accordion-item-body">
                      <vue-json-compare :oldData="jsonSchemas[response.json_schema]"
                                        :newData="combinations[combination.json_schema]"></vue-json-compare>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import vueJsonCompare from 'vue-json-compare'

export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  components: {
    vueJsonCompare
  },
  data() {
    return {
      myJson: {'stub': 'for action page'},
      jsonSchemas: {'stub': 'json-schemas'},
      combinations: {'stub': 'combinations'},
      tests: {'stub': 'tests'}
    }
  },
  methods: {
    accordion: function (event) {
      event.target.classList.toggle('active');
    }
  }
}
</script>

<style>
.request {
  color: #42b983;
  background-color: #273645;
  padding: 0px 0px 0px 8px;
}

.tests_without_responses {
  text-align: left;
  padding: 0px 0px 0px 8px;
  color: #b94283;
  background-color: #273645;
  margin: 2px 0px 0px 24px;
}

.tests_without_responses:hover {
  background-color: #2b2b2b;
}

.test_without_responses {
  text-align: left;
  padding: 0px 0px 0px 8px;
  color: #b94283;
  background-color: #273645;
  margin: 2px 0px 0px 32px;
}

.test_without_responses:hover {
  background-color: #2b2b2b;
}

.response {
  text-align: left;
  padding: 0px 0px 0px 8px;
  color: #42b983;
  background-color: #273645;
  margin: 2px 0px 0px 24px;
}

.response:hover {
  background-color: #2b2b2b;
}

.response_good {
  color: #42b983;
}

.response_bad {
  color: #b94283;
}

.combination {
  text-align: left;
  padding: 0px 0px 0px 8px;
  color: #42b983;
  background-color: #273645;
  margin: 2px 0px 0px 32px;
}

.combination:hover {
  background-color: #2b2b2b;
}

/* darkmode */
.alpaca-json{
  background-color: #131a20;
}
.alpaca-add{
  background-color: #004313;
}
.alpaca-del {
  background-color: #160004;
}
.alpaca-upd{
  background-color: #423200;
}
</style>