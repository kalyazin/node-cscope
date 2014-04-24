path = require 'path'
cscope = require '../lib/cscope'

describe 'cscope', ->
  db = null
  foo = null

  beforeEach ->
    db = path.join __dirname, 'fixtures', 'cscope_2.out'
    foo =
      cb: (res) ->
        undefined
    spyOn(foo, 'cb')

  it 'find callers', ->
    cscope.findCallers 'fill_data_msg_head', { refFile: db }, foo.cb

    waitsFor ->
      foo.cb.callCount is 1

    runs ->
      args = foo.cb.mostRecentCall.args
      expect(args.length).toEqual(1)

      res = args[0]
      expect(res.length).toEqual(4)

      expect(res[0].file).toEqual('daemon/da_data.c')
      expect(res[0].sym).toEqual('gen_message_terminate')
      expect(res[0].line).toEqual('225')
      expect(res[0].ctx)
        .toEqual('fill_data_msg_head(data,NMSG_TERMINATE, 0, payload_len);')

