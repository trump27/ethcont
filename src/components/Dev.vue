<template>
  <div id="app">
    <h1>Contract</h1>

    <div v-if="msgInfo" class="alert alert-success">{{msgInfo}}</div>
    <div v-if="msgWarn" class="alert alert-warning">{{msgWarn}}</div>

    <h2>Contract methods</h2>
    <button @click="loadContract" class="btn btn-primary">Load my contract</button>


    <form class="form-horizontal" role="form">
      <div class="form-group">
        <legend>Add data</legend>
      </div>

      <div class="input-group">
        <div class="input-group-addon">Name</div>
        <input v-model="cust.name" type="text" class="form-control" placeholder="string">
      </div>

      <div class="input-group">
        <div class="input-group-addon">Fullname</div>
        <input v-model="cust.fullname" type="text" class="form-control" placeholder="string">
      </div>

      <div class="input-group">
        <div class="input-group-addon">Amount</div>
        <input v-model="cust.amount" type="text" class="form-control" placeholder="int">
      </div>

      <div class="form-group">
        <div class="col-sm-10">
          <button @click.prevent="registCust" class="btn btn-success">Regist Cust</button>
        </div>
      </div>
    </form>


    <table class="table table-condensed table-hover">
      <tr>
        <th>Name</th><th>Fullname</th><th>Amount</th>
      </tr>
      <tr v-for="item in items">
        <td>{{item.name}}</td><td>{{item.fullname}}</td><td>{{item.amount}}</td>
      </tr>
    </table>

  </div>
</template>

<script>
import Web3 from '../w3'
import contracts from '../../contract/contracts.json'
// import my_sol from 'raw!../../contract/my.sol'
var web3
var contractInstance

export default {
  data () {
    return {
      source: '',
      msgInfo: '',
      msgWarn: '',
      abi: '',
      myContract: null,
      cust: {
        name: '',
        fullname: '',
        amount: null
      },
      items: []
    }
  },
  created () {
    web3 = Web3.web3()
    web3.eth.defaultAccount = web3.eth.accounts[0]
    // this.source = my_sol
    this.loadContract()
    this.listData()
  },
  methods: {
    loadContract () {
      const cont = 'my.sol'
      var abi = contracts[cont].abi
      var contract = web3.eth.contract(abi)
      contractInstance = contract.at(contracts[cont].id)
      console.log(contractInstance)
    },
    listData () {
      var cnt = contractInstance.getCount()
      console.log(cnt.toString())
      for (var i = 0; i < cnt.toNumber(); i++) {
        var r = contractInstance.get.call(i)
        this.items.push({
          name: r[0].toString(),
          fullname: r[1].toString(),
          amount: r[2].toNumber()
        })
        console.log(r)
      }
    },
    registCust () {
      this.msgInfo = this.msgWarn = ''
      var self = this
      contractInstance.regist(
        this.cust.name,
        this.cust.fullname,
        this.cust.amount,
        // {gas: 500000},
        function (err, result) {
          if (err) {
            self.msgWarn = err
            console.log(err)
            return
          }
          self.msgInfo = result
          console.log(result)

          var txhash = result
          var filter = web3.eth.filter('latest')
          filter.watch(function (error, result) {
            if (error) console.log(error)
            // XXX this should be made asynchronous as well.  time
            // to get the async library out...
            var receipt = web3.eth.getTransactionReceipt(txhash)
            // XXX should probably only wait max 2 events before failing XXX
            if (receipt && receipt.transactionHash === txhash) {
              var res = contractInstance.getCount.call()
              console.log('the transactionally incremented data was: ' + res.toString(10))
              filter.stopWatching()
            }
          })
        }
      )
    }
  }
}
</script>

<style lang="stylus" scoped>
form
  margin-top 20px
.input-group-addon
  width 120px
</style>
