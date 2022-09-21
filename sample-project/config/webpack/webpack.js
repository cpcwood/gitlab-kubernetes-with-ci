const path = require('path')
const rootPath = path.resolve(__dirname, '../../')

module.exports = {
  entry: './app/javascript/application.js',
  resolve: {
    modules: [path.resolve(rootPath, 'app/javascript'), 'node_modules'],
  },
  output: {
    path: path.resolve(rootPath, 'build'),
    filename: '[name].[contenthash].js',
    clean: true,
    assetModuleFilename: 'assets/[name]-[hash][ext][query]'
  }
}