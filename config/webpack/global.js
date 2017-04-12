'use strict';

// Depends
var path         = require('path');
var webpack      = require('webpack');
var Manifest     = require('manifest-revision-webpack-plugin');
var TextPlugin   = require('extract-text-webpack-plugin');
var SvgStore     = require('webpack-svgstore-plugin');
var jsonPresent  = require('./helpers/json-presenter');
var autoprefixer = require('autoprefixer-core');

var rootAssetPath = './app/webpack';
var manifestIgnorePaths = [
  '/stylesheets', '/javascript', '/logos', '/svg', '/svgs', '/icons', '.DS_Store'
];

function appName() {
  if (process.env.NODE_ENV === 'developmentFront') return 'front';
  if (process.env.NODE_ENV === 'productionFront') return 'front';
  if (process.env.NODE_ENV === 'developmentMobile') return 'mobile';
  if (process.env.NODE_ENV === 'productionMobile') return 'mobile';
}

/**
 * Global webpack config
 * @param  {[type]} _path [description]
 * @return {[type]}       [description]
 */
module.exports = [function(_path) {
  // define local variables
  var dependencies  = Object.keys(require(_path + '/package').dependencies);

  // return object
  return {

    // entry points
    entry: {
      //ramblertopline: path.join(_path, 'app/webpack/javascripts', 'ramblertopline.js'),
      application: path.join(_path, 'app/webpack/javascripts', appName(), 'application.js'),
      vendors: dependencies
    },

    // output system
    output: {
      path: path.join(_path, 'public', 'assets', '' + appName() + ''),
      filename: '[chunkhash].[name].js',
      chunkFilename: '[chunkhash].[hash].[id].js',
      publicPath: '/assets/' + appName() + '/'
    },

    // resolves modules
    resolve: {
      extensions: ['', '.js', '.styl'],
      modulesDirectories: ['vendor/webpack', 'node_modules'],
      alias: {
        _app: path.join(_path, 'app', 'webpack'),
        _js: path.join(_path, 'app', 'webpack', 'javascripts'),
        _stylesheets: path.join(_path, 'app', 'webpack', 'stylesheets'),
        _templates: path.join(_path, 'app', 'webpack', 'templates'),
        _images: path.join(_path, 'app', 'webpack', 'images')
      }
    },
    module: {
      loaders: [
        { test: /\.jsx?$/, exclude: /(node_modules|autoprefixer|d3)/, loader: 'babel?presets[]=es2015'},
        { test: /\.jade$/, loader: 'jade' },
        { test: /\.(ttf|eot|otf|woff|woff2)$/i, loaders: ['file'] },
        { test: /\.styl$/i, loader: TextPlugin.extract('style', 'css!postcss!stylus') },
        { test: /\.css$/i, loader: TextPlugin.extract('style', 'css') },
        { test: /\.(png|ico|jpg|jpeg|gif|svg)$/i, loaders: ['file?context=' + rootAssetPath + '&name=[path][hash].[name].[ext]'] }
      ],
      noParse: /\.DS_Store/,
    },

    postcss: [autoprefixer({ browsers: ['last 5 versions'] })],

    // load plugins
    plugins: [
      new webpack.DefinePlugin({
        'NODE_ENV': JSON.stringify(process.env.NODE_ENV)
      }),

      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        'window.jQuery': 'jquery'
      }),

      new webpack.ProvidePlugin({
        Promise: 'imports?this=>global!exports?global.Promise!es6-promise',
        fetch: 'imports?this=>global!exports?global.fetch!whatwg-fetch'
      }),

      new webpack.optimize.CommonsChunkPlugin('vendors', '[hash].vendors.js'),

      new TextPlugin('[chunkhash].[name].css'),
      new SvgStore({
        prefix: 'icon-'
      }),
      new Manifest(path.join(_path + '/config', 'manifest.' + appName() + '.json'), {
        rootAssetPath: rootAssetPath,
        ignorePaths: manifestIgnorePaths,
        format: jsonPresent
      }),

    ],
  };
}, function(_path) {
  return {
    entry: {
      ramblertopline: path.join(_path, 'app/webpack/javascripts', 'ramblertopline.js')
    },

    output: {
      path: path.join(_path, 'public', 'assets', appName()),
      filename: '[chunkhash].[name].js',
      publicPath: '/assets/' + appName() + '/'
    },
    module: {
      loaders: [
        { test: /\.jsx?$/, exclude: /(node_modules|autoprefixer|d3)/, loader: 'babel?presets[]=es2015'},
        { test: /\.jade$/, loader: 'jade' },
        { test: /\.(ttf|eot|otf|woff|woff2)$/i, loaders: ['file'] },
        { test: /\.styl$/i, loader: TextPlugin.extract('style', 'css!postcss!stylus') },
        { test: /\.css$/i, loader: TextPlugin.extract('style', 'css') },
        { test: /\.(png|ico|jpg|jpeg|gif|svg)$/i, loaders: ['file?context=' + rootAssetPath + '&name=[path][hash].[name].[ext]'] }
      ],
      noParse: /\.DS_Store/,
    },
    resolve: {
      extensions: ['', '.js', '.styl'],
      modulesDirectories: ['vendor/webpack', 'node_modules']
    },
    module: {
      loaders: [
        { test: /\.jsx?$/, exclude: /(node_modules|autoprefixer|d3)/, loader: 'babel?presets[]=es2015'},
        { test: /\.jade$/, loader: 'jade' },
        { test: /\.(ttf|eot|otf|woff|woff2)$/i, loaders: ['file'] },
        { test: /\.styl$/i, loader: TextPlugin.extract('style', 'css!postcss!stylus') },
        { test: /\.css$/i, loader: TextPlugin.extract('style', 'css') },
        { test: /\.(png|ico|jpg|jpeg|gif|svg)$/i, loaders: ['file?context=' + rootAssetPath + '&name=[path][hash].[name].[ext]'] }
      ],
      noParse: /\.DS_Store/,
    },
    plugins: [
      new Manifest(path.join(_path + '/config', 'manifest.ramblertopline.json'), {
        rootAssetPath: rootAssetPath,
        ignorePaths: manifestIgnorePaths,
        format: jsonPresent
      }),
    ]
  };
}];
