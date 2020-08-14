<template>
  <div id="main">
    <div v-for="prefix in myJson.prefixes_details">
      <div v-if="$route.query.prefix == prefix.name" class="accordion-item">
        <div class="prefix">
          <div class="prefix-name">{{prefix.name}}</div>
        </div>
        <div v-for="action in prefix.actions.actions_details">
          <div v-if="$route.query.method == action.method && $route.query.path == action.path" class="accordion-item">
            <div class="action">
              <div class="method">{{action.method}}</div>
              <div class="path">{{action.path}}</div>
            </div>
              <div v-for="response in action.responses.responses_details">
                <div class="response">
                  <div class="accordion-item">
                    <div class="accordion-item-head" v-on:click="accordion">
                      {{response.combinations.combinations_cover_percent}} {{response.method}}
                    </div>
                    <div class="accordion-item-body">
                      <vue-json-compare :oldData="response.json_schema" :newData="response.json_schema"></vue-json-compare>
                    </div>
                  </div>
                </div>
                <div v-for="combination in response.combinations.combinations_details">
                  <div class="combination">
                    <div class="accordion-item">
                      <div class="accordion-item-head" v-on:click="accordion">
                        type: {{combination.type}}, name: {{combination.name}}, tests_size: {{combination.tests_size}}
                      </div>
                      <div class="accordion-item-body">
                        <vue-json-compare :oldData="response.json_schema" :newData="combination.json_schema"></vue-json-compare>
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
      myJson: {'stub': 'for action page'}
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

/* accordion */
.accordion-item{
  position: relative;
}
.accordion-item-head{
  border-top-left-radius: 5px ;
  border-top-right-radius: 5px;
  cursor: pointer;
}
.accordion-item-head:after{
  content: ' > ';
  display: block;
  position: absolute;
  right: 25px;
  transform: rotate(90deg) scaleY(2);
  top: 0px;
}
.accordion-item-head.active:after{
  content: ' < ';
}
.accordion-item-body{
  display: none;
}
.accordion-item-head.active + .accordion-item-body{
  display: block !important;
}
</style>