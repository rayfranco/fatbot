#!/usr/bin/env node
import program from 'commander'
import Bot from './lib/fatbot'
import { exec } from 'child_process'

if (require.main === module) {
  program
    .version('1.0.0')
    .option('-b, --bot', 'Bot file')

  program
    .command('*')
    .description('Start a bot')
    .action(function(bot){
      let child = exec(`npm run bot -- ${bot}`,
        function (error, stdout, stderr) {
          console.log('stdout: ' + stdout)
          console.log('stderr: ' + stderr)
          if (error !== null) {
            console.log('exec error: ' + error)
          }
      })
    })

  program.parse(process.argv)
}

export default Bot
