var fs = require('fs-extra');
var path = require('path');
var filterxml = require('filterxml');

/**
 * REMOVE FILES THAT CURRENTLY DO NOT DEPLOY WELL
 */

// Social Post has strange dependencies that require certain features to be enabled in an org manually
fs.removeSync('./force-app/main/default/layouts/SocialPost-Social Post Layout.layout-meta.xml');

// Managed Package Business Processes must be retrieved differently - we don't use these so they can be safely removed
fs.removeSync('./force-app/main/default/objects/Lead/businessProcesses/HealthCloudGA__LeadToPatientProcess.businessProcess-meta.xml');
fs.removeSync('./force-app/main/default/objects/Lead/businessProcesses/HealthCloudGA__Referral.businessProcess-meta.xml');

// Reference to missing field - though rule is deactivated
fs.removeSync('./force-app/main/default/objects/HealthCloudGA__CarePlanProblem__c/validationRules/PAL_Required_for_Nurse_Allies.validationRule-meta.xml');

// TEMP: Remove Search Settings until we can determine which object is not correctly being pushed
fs.removeSync('./force-app/main/default/settings/Search.settings-meta.xml');


profileDir = './force-app/main/default/profiles/';
outDir = './force-app/main/default/profiles/';

//outDir = './out/';

/**
 * REMOVE PROFILE INFORMATION
 */

//Remove problematic page layouts from profiles
var patterns = [
    '/xmlns:Profile/xmlns:layoutAssignments/xmlns:layout[text()=\'SocialPersona-Social Persona Layout\']/parent::xmlns:layoutAssignments',
    '/xmlns:Profile/xmlns:layoutAssignments/xmlns:layout[text()=\'SocialPost-Social Post Layout\']/parent::xmlns:layoutAssignments',
];

var namespaces = {
    'xmlns' : 'http://soap.sforce.com/2006/04/metadata',
    null: 'http://soap.sforce.com/2006/04/metadata'

};

fs.readdir(profileDir, function (err, files) {
    if (err) {
      console.error("Could not list the directory.", err);
      process.exit(1);
    }
  
    files.forEach(function (file, index) {
      // Make one pass and make the file complete
      var sourcePath = path.join(profileDir, file);
      var targetPath = path.join(outDir, file);

        fs.readFile(sourcePath, function (errr, inXml) {
            if (errr) {
                throw errr;
            }
            
            filterxml(inXml, patterns, namespaces,function (errf, outXml) {
                if (errf) {
                  throw errf;
                }
          
                fs.writeFile(targetPath, outXml, function (errw) {
                  if (errw) {
                    throw errw;
                  }
                });
            });
        });
    });
  });