describe 'npm-postinstall', ->
  mocks = require 'mocks'
  path = require 'path'
  module = mockFs = _mocks = null
  mockPackageJSON = sharedKarmaFiles: 'foo.json': '.foo.json'

  _globals = __dirname: '/test/project/node_modules/shared-karma-files/bin'

  runPostInstallScript = ->
    module = mocks.loadFile __dirname + '/../lib/npm-postinstall', _mocks, _globals
    module.main()

  beforeEach ->
    mockFs = mocks.fs.create
      test: project: node_modules: 'shared-karma-files': shared:
                  'foo.json': mocks.fs.file 0

    mockFs.unlink = @sinon.stub().callsArg(1)
    mockFs.symlink = @sinon.stub()

    _mocks =
        'fs': mockFs
        '/test/project/package.json': mockPackageJSON


  # Postinstall script should create
  # relative symlink
  it 'should create relative symlink', ->
    runPostInstallScript()

    sinon.assert.calledWith(mockFs.symlink, 'node_modules/shared-karma-files/shared/foo.json', '/test/project/.foo.json')
