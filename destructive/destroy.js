var tools = require('jsforce-metadata-tools');
var execSync = require('child_process').execSync;
var fs = require('fs');
var path = require('path');

var program = require('commander');
program
  .option('-d, --destroyDir <destroyDir>', 'the path to the destruction directory')
  .option('-u, --orgname <orgname>', 'the sfdx org name to connect to')
  .parse(process.argv);

var logger = (function (fs) {
    var buffer = '';
    return {
        log: log,
        flush: flush
    };
    function log(val) {
        buffer += (val + '\n');
    }
    function flush() {
        var logFile = path.resolve((process.env.CIRCLE_ARTIFACTS || '.') + '/DeployStatistics.log');
        fs.appendFileSync(logFile, buffer, 'utf8');
        buffer = '';
    }
} (fs));

// Deploy the Code from a directory
var deployDestructiveChanges = function(){
    if(fs.existsSync(program.destroyDir + '/destructiveChanges.xml')){
        console.log('Found ' + program.destroyDir + '/destructiveChanges.xml');

        tools.deployFromDirectory(program.destroyDir, connInfo).then(function (res) {
            tools.reportDeployResult(res, logger, connInfo.verbose);
            logger.flush();
            if (!res.success || res.numberTestErrors > 0 || res.numberComponentErrors > 0) {
                console.error('Destructive changes were NOT Successful');
                process.exit(1);
            } else {
                console.error('Destructive changes were Successful');
                process.exit(0);
            }
        }).catch(function (err) {
            console.error(err.message);
            process.exit(1);
        });
    }
};

const javaInfo = execSync('sfdx force:org:display -u ' + program.orgname + ' --verbose --json').toString();
var connInfo = JSON.parse(javaInfo).result;

connInfo.purgeOnDelete = true;
connInfo.pollTimeout = 600000;
connInfo.pollInterval = 15000;
connInfo.rollbackOnError = false;
connInfo.ignoreWarnings = true;
connInfo.verbose = true;

deployDestructiveChanges();