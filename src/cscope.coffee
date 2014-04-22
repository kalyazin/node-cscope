# TODO: rename methods in a consistent way
# TODO: Gruntfile.coffee (refer to github.com/atom/node-ctags)
# TODO: add tests
# TODO: move all this to github issues

nexpect = require 'nexpect'

findSymbolCmd = "1"
funcsCalledByCmd = "2"
funcsCallingCmd = "3"
findTextStringCmd = "4" # FIXME: only same dir
# changeTextStringCmd = "5" # TODO: do i need this at all?
findEgrepPatternCmd = "6"
findFileCmd = "7"
findFilesIncludingCmd = "8"
findAssignCmd = "9"

symbolToSearch = process.argv[2]
dbPath = process.argv[3]
if !symbolToSearch || !dbPath
    console.log "Usage: coffee cscope.coffee <symbol> <db>"
    process.exit 1

genericFind = (cmd, symbol, db, callback) ->
    cscopeRegex = /cscope: (\d+) lines/
    outputRegex = /([\w.\/]+)\s+([a-zA-Z_$][\w$]+|<unknown>)\s+(\d+)\s+(.+)/
    prompt = ">> "
    quitCmd = "q"

    nexpect.spawn "cscope"
        , ["-d", "-k", "-l", "-f" + db]
        .expect prompt
        .sendline cmd + symbolToSearch
        .expect cscopeRegex
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

findSymbol = (symbol, db, callback) ->
    genericFind findSymbolCmd, symbol, db, callback

funcsCalledBy = (symbol, db, callback) ->
    genericFind funcsCalledByCmd, symbol, db, callback

funcsCalling = (symbol, db, callback) ->
    genericFind funcsCallingCmd, symbol, db, callback

findTextString = (symbol, db, callback) ->
    genericFind findTextStringCmd, symbol, db, callback

# changeTextString = (symbol, db, callback) ->
    # genericFind changeTextStringCmd, symbol, db, callback

findEgrepPattern = (symbol, db, callback) ->
    genericFind findEgrepPatternCmd, symbol, db, callback

findFile = (symbol, db, callback) ->
    genericFind findFileCmd, symbol, db, callback

findFilesIncluding = (symbol, db, callback) ->
    genericFind findFilesIncludingCmd, symbol, db, callback

findAssign = (symbol, db, callback) ->
    genericFind findAssignCmd, symbol, db, callback

printResult = (results) ->
    for r in results
        console.log "file: #{r.file}, sym: #{r.sym}, line: #{r.line}"

# findSymbol symbolToSearch, dbPath, printResult
# funcsCalledBy symbolToSearch, dbPath, printResult
# funcsCalling symbolToSearch, dbPath, printResult
# findTextString symbolToSearch, dbPath, printResult
# changeTextString symbolToSearch, dbPath, printResult
findEgrepPattern symbolToSearch, dbPath, printResult
# findFile symbolToSearch, dbPath, printResult
# findFilesIncluding symbolToSearch, dbPath, printResult
# findAssign symbolToSearch, dbPath, printResult
