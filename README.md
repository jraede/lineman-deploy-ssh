lineman-deploy-ssh
==================

This plugin allows you deploy your Lineman project via SSH to any server you have access shell access for.

## Installation
In your project root, just type `npm install --save lineman-deploy-ssh` in your terminal.

## Setup
To set up a deployment target to use SSH, you need to add an entry to your application config file under `deployment`:

```javascript
module.exports = function(lineman) {
  return {
    deployment:{
      target_name:{
        // Tell Lineman to use this plugin for deployment
        method:'ssh',
        host:'host domain or IP',
        dest:'destination path on host',
        authKey:'authorization credentials - see below'
        
        // Tell Lineman whether or not to run spec-ci before deploying
        runTests:true/false
      }
    }
  };
};
```

Once you have everything configured, you just need to run `lineman deploy target_name` in the terminal.

## Configuration

**host** - This is the IP address or the domain name (no protocol) of the server you are deploying to.

**dest** - The path on the server to deploy your files. E.g. `'/var/www/public/'`

**authKey** - This is the key in your `.ssh` JSON file that holds your credentials. Note that this should typically not be checked into version control, as each developer will have his or her own credentials.

### The .ssh file

In your project root, create a file caled `.ssh`, which will hold JSON data for your SSH credentials. This plugin allows for two different authentication methods - **username/password** and **privateKey**. It is up to you which one to use.

Your .ssh file should look like this:

```json
{
  "username_password":{
    "username":"my_user_name",
    "password":"my_password"
  },
  
  "explicit_private_key":{
    "username":"my_user_name",
    "privateKey":"/path/to/id_rsa"
  }
}
```

Note that if you have a private key loaded by default in your shell, if you do not specify a `privateKey` parameter, the plugin will try to use your system's default SSH agent, which typically will use your existing private key without any additional configuration.
  

