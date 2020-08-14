<template>
  <div>
    Action page
    <p>{{this.$route.query.prefix}}</p>
    <p>{{this.$route.query.method}} {{this.$route.query.path}}</p>
    <div v-for="data in myJson.prefixes_details">
      <div v-if="$route.query.prefix == data.name" class="accordion-item">
        <div v-for="action in data.actions.actions_details">
          <div v-if="$route.query.method == action.method && $route.query.path == action.path" class="accordion-item">
            <div class="action">
              <div class="request">{{action.method}} {{action.path}}, test {{action.tests_size}}</div>
              <div v-for="response in action.responses.responses_details">
                <div class="response">response code {{ response.method }}, tests_size {{ response.tests_size }}</div>
                <div v-for="combination in response.combinations.combinations_details">
                  <div class="combination">
                    <div class="accordion-item">
                      <div class="accordion-item-head" v-on:click="accordion">
                        type: {{combination.type}}, name: {{combination.name}}, tests_size: {{combination.tests_size}}
                      </div>
                      <div class="accordion-item-body">
                        <vue-json-compare :oldData="combination.json_schema" :newData="combination.json_schema"></vue-json-compare>
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
.action {
  color: #42b983;
}

.request {
  background-color: #273645;
  padding: 0px 0px 0px 8px;
}

.response {
  background-color: #273645;
  margin: 2px 0px 0px 16px;
}

.combination {
  background-color: #273645;
  margin: 2px 0px 0px 24px;
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
  padding:10px;
}
.accordion-item-head:after{
  content: ' > ';
  display: block;
  height: 29px;
  position: absolute;
  right: 25px;
  transform: rotate(90deg) scaleY(2);
  top: 8px;
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