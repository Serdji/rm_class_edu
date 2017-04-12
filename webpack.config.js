'use strict';

// Depends
var _ = require('lodash');

/**
 * [config description]
 * @type {Object}
 */
var _configs = {
  // global section
  global: require(__dirname + '/config/webpack/global'),

  // config by enviroments
  developmentFront: require(__dirname + '/config/webpack/development'),
  productionFront: require(__dirname + '/config/webpack/production'),
  developmentMobile: require(__dirname + '/config/webpack/development'),
  productionMobile: require(__dirname + '/config/webpack/production'),
  staging: require(__dirname + '/config/webpack/production'),
};

/**
 * Load webpack config via enviroments
 * @param  {[type]} enviroment [description]
 * @return {[type]}            [description]
 */
var _load = function(enviroment) {

  // check enviroment
  if (!enviroment) throw 'Can\'t find local enviroment variable via process.env.NODE_ENV';
  if (!_configs[enviroment]) throw 'Can\'t find enviroments see _configs object';

  // load config file by enviroment

  function buildConfig(globalConfig) {
    return _configs && _.merge(
      _configs[enviroment](__dirname),
      globalConfig
    );
  }

  var global = _configs['global'];

  if (global instanceof Array) {
    return global.map(function(callback) {
      return buildConfig(callback(__dirname));
    });
  } else {
    return buildConfig(global(__dirname));
  }
};

/**
 * Export WebPack config
 * @type {[type]}
 */
module.exports = _load(process.env.NODE_ENV);
