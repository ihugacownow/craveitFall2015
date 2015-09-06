
var fs = require('fs');
var layer = require('cloud/layer-parse-module/layer-module.js');
var layerProviderID = 'layer:///providers/f3a716ba-53bd-11e5-a3bf-faf6260261bc';
var layerKeyID = 'layer:///keys/d31ae0b2-53c1-11e5-8597-faf6260261bc';
var privateKey = fs.readFileSync('cloud/layer-parse-module/keys/layer-key.js');
layer.initialize(layerProviderID, layerKeyID, privateKey);

Parse.Cloud.define("generateToken", function(request, response) {
    var currentUser = request.user;
    if (!currentUser) throw new Error('You need to be logged in!');
    var userID = currentUser.id;
    var nonce = request.params.nonce;
    if (!nonce) throw new Error('Missing nonce parameter');
        response.success(layer.layerIdentityToken(userID, nonce));
});

// Use Parse.Cloud.define to define as many cloud functions as you want.

// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
