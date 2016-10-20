#!/usr/bin/env node

var program = require('commander')
var exec = require('child_process').execSync
var colors = require('colors')
var fs = require('fs')
var path = require('path')

var header = '[' + 'fatbot-cli'.bold + '] '

program
  .version('1.0.0')

program
  .command('*')
  .action(function(bot){

    console.log(header.cyan + 'Loading your bot from '+ bot.bold.green)

    var stats = fs.lstatSync(bot)

    if (!stats.isFile()) {
      console.log(header.red + 'No bot found :(')
    }

    console.log(header.green + 'Bot found ! :)')

    exec('npm run start -- ' + bot, {
      stdio: [0, 1, 2]
    }, function (error, stdout, stderr) {
      if (error !== null) {
        console.log('Error: ' + error)
      }
    })
  })

program.parse(process.argv)
