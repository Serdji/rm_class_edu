'use strict';

module.exports = function(_path) {
  return {
    context: _path,
    debug: true,
    devtool: 'eval',
    module: {
      preLoaders: [
        { test: /\.jsx?$/, exclude: /(node_modules|autoprefixer|d3)/, loader: 'babel?presets[]=es2015' }
      ]
    },
    devServer: {
      contentBase: _path + '/app/assets',
      proxy: {
        '*': 'http://localhost:3000'
      }
    }
  };
};
