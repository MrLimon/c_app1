List<User> oldUsers = [SELECT id, username, isActive, Profile.Name FROM User where Profile.Name IN 
    ('Admin Team',
    'Impact NoAuth',
    'Leadership w Edit on SD Functions',
    'Leadership without Auth',
    'M360 Admin',
    'Support Ally Clone for Testing',
    'tempadmin',
    'TempEMO')
];

System.debug(oldUsers);

id standardProfileId = [SELECT id FROM Profile where Name='Standard User'][0].id;
for (User u : oldUsers) {
    u.ProfileId = standardProfileId;
}

if (!oldUsers.isEmpty()){
    update oldUsers;
}