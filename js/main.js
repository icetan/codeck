require('coffee-script', true);
var CODECK = require('./codeck');

module.exports = function (container) {
  this.codeck = new CODECK(container);
  this.codeck.start();
};
