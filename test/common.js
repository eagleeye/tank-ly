var chai = require('chai');
chai.config.includeStack;
global.chai = chai;
global.expect = chai.expect;
require('chai-subset').addMethods(chai);
