nexpect = require 'nexpect'

cmd =
  findSymbol: '1'
  findCallees: '2'
  findCallers: '3'
  findFile: '7'
  findIncluders: '8'
  findAssignments: '9'

genericFind = (cmd, symbol, options, callback) ->
  cscopeRegex = /cscope: (\d+) lines/
  outputRegex = /([\w.\/]+)\s+([a-zA-Z_$][\w$]+|<unknown>)\s+(\d+)\s+(.+)/
  prompt = ">> "
  quitCmd = "q"

  opts = ['-l', '-k', '-d']
  opts.push '-f' + options.refFile if options.refFile

  nexpect.spawn "cscope", opts
    .expect prompt
    .sendline cmd + symbol
    .wait cscopeRegex
    .sendline quitCmd
    .run (err, stdout, exitcode) ->
      if err
        console.log "could not invoke cscope (#{err})"
        process.exit 1
      header = stdout[1].match(cscopeRegex)
      lines = parseInt(header[1])
      if lines == 0 # no such symbol
        return null

      startIdx = 2
      res = []
      drop_next = null
      # for line in [startIdx..startIdx + lines - 1]
      padding = 3 # 2 x ">>" and lines count
      # FIXME: ugly hack
      for line in [startIdx..startIdx + (stdout.length - padding) - 1]
        if drop_next
          drop_next = null
          continue
        m = stdout[line].match(outputRegex)
        if !m # broken line
          m = (stdout[line] + stdout[line + 1]).match(outputRegex)
          drop_next = 1
        res.push
          file: m[1]
          sym:  m[2]
          line: m[3]
          ctx:  m[4]
      callback res

module.exports =
  findSymbol: (symbol, options, callback) ->
    genericFind cmd.findSymbolCmd, symbol, options, callback
  findCallees: (symbol, options, callback) ->
    genericFind cmd.findCallees, symbol, options, callback
  findCallers: (symbol, options, callback) ->
    genericFind cmd.findCallers, symbol, options, callback
  findFile: (symbol, options, callback) ->
    genericFind cmd.findFile, symbol, options, callback
  findIncluders: (symbol, options, callback) ->
    genericFind cmd.findIncluders, symbol, options, callback
  findAssignments: (symbol, options, callback) ->
    genericFind cmd.findAssignments, symbol, options, callback
