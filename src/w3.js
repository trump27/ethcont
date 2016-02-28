import Web3 from 'Web3'
var web3instance

export default {
  web3 () {
    if (!web3instance) {
      web3instance = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
    }
    return web3instance
  }
}
