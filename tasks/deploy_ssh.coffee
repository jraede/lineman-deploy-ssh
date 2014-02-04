module.exports = (grunt) ->
	_ = grunt.util._
	grunt.registerTask "lineman-deploy-ssh", "deploy via ssh", (target) ->
		config = grunt.config.get('deployment.' + target)
		# Failsafe here
		if config.method isnt 'ssh'
			return grunt.log.error('Deployment method for target "' + target + '" is not SSH - aborting!')

		# Config already checked in the core deploy task


		# Look for the auth information
		fs = require('fs')
		if !fs.existsSync(process.cwd() + '/.ssh')
			return grunt.log.error('.ssh file not found in project root. Aborting!' + process.cwd() + '/.ssh')

		sshInfo = JSON.parse(fs.readFileSync(process.cwd() + '/.ssh'))
		authKey = config.authKey
		if !authKey?
			return grunt.log.error('authKey parameter not found in deployment config. Aborting!')

		authInfo = sshInfo[authKey]
		if !authInfo?
			return grunt.log.error('Key "' + authKey + '" not found in .ssh file. Aborting!')
			
		options =
			path:config.dest
			host:config.host
			srcBasePath:"dist/"
			createDirectories:true
			showProgress:true
		# Turn private key path into actual private key for usage in connection
		if authInfo.privateKey?
			authInfo.privateKey = fs.readFileSync(authInfo.privateKey).toString()

		# Otherwise use the executing user's SSH agent, which will use their default private key
		else
			authInfo.agent = process.env.SSH_AUTH_SOCK


		options = _.extend(options, authInfo)


		grunt.config.set 'sftp', 
			lineman:
				files:
					'./':'dist/**'
				options:options
		tasks = ['sftp:lineman']

		grunt.task.run(tasks)
