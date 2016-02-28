<template>
  <div id="app">
    <h1>Contract deploy</h1>
    <h2>Selected contract</h2>

    <div v-if="msgInfo" class="alert alert-success">{{msgInfo}}</div>
    <div v-if="msgWarn" class="alert alert-warning">{{msgWarn}}</div>

    <select v-model="selected" @change="loadContractInfo" class="form-control" required="required">
      <option v-for="option in contracts" v-bind:value="option">{{option}}</option>
    </select>

    <h2>Deploy</h2>
    <button @click="compile" class="btn btn-primary">Compile &amp; Deploy</button>
    <div v-if="contractId">
      contract:<pre>{{contractId}}</pre>
    </div>
    <div v-if="abi">
      abi:<pre>{{abi}}</pre>
    </div>
    <div>
      source:<pre>{{currentSource}}</pre>
    </div>

  </div>
</template>

<script>
import Web3 from '../w3'
import contractsJson from '../../contract/contracts.json'
var mdlsrc = require.context('raw!../../contract')

var web3

export default {
  data () {
    return {
      msgInfo: '',
      msgWarn: '',
      selected: null,
      contracts: [],
      currentSource: '',
      abi: '',
      contractId: ''
    }
  },
  watch: {
    'selected': function (val) {
      console.log(val)
      this.loadContractInfo(val)
    }
  },
  created () {
    web3 = Web3.web3()
    web3.eth.defaultAccount = web3.eth.accounts[0]
    this.listContracts()
  },
  methods: {
    listContracts () {
      for (var key in contractsJson) {
        this.contracts.push(key)
      }
      if (this.contracts.length > 0) this.selected = this.contracts[0]
    },
    loadContractInfo (cont) {
      this.msgInfo = this.msgWarn = ''
      var src = mdlsrc('./' + this.selected)
      this.abi = ''; this.contractId = ''
      this.currentSource = src
    },
    /**
     * compile & deploy
     */
    compile () {
      if (!web3.eth.mining) {
        window.alert('not mining')
        return
      }
      var inputSrc = this.currentSource
      inputSrc = inputSrc.replace(/\r?\n/g, ' ')
      inputSrc = inputSrc.replace(/\s+/g, ' ')
      var compiled = web3.eth.compile.solidity(inputSrc)
      console.log(compiled)

      var contkey
      for (var key in compiled) {
        contkey = key
      }

      var code = compiled[contkey].code
      var abi = compiled[contkey].info.abiDefinition
      this.abi = JSON.stringify(abi)
      this.deploy(abi, code)
    },
    deploy (abi, code) {
      var self = this
      this.msgInfo = this.msgWarn = ''
      var myContract = web3.eth.contract(abi)
      myContract.new({
        data: code,
        gas: 900000
      },
      function (err, contract) {
        if (err) self.msgWarn = err
        if (!contract.address) {
          self.msgWarn = 'wait for mining.... tx: ' + contract.transactionHash
        } else {
          self.msgWarn = ''
          self.msgInfo = 'contract: ' + contract.address
          self.contractId = contract.address
        }
      })
    }
  }
}
</script>
