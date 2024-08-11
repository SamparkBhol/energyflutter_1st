const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const energyPrediction = require('./energy_prediction');
const tradingLogic = require('./trading_logic');
const authHooks = require('./auth_hooks');

// Main entry point for Firebase functions
exports.predictEnergyUsage = functions.firestore
  .document('users/{userId}/usage/{usageId}')
  .onCreate((snap, context) => {
    return energyPrediction.predictUsage(context.params.userId);
  });

exports.handleEnergyTrading = functions.firestore
  .document('offers/{offerId}')
  .onUpdate((change, context) => {
    return tradingLogic.handleTrade(change.before.data(), change.after.data());
  });

exports.onUserCreate = functions.auth.user().onCreate((user) => {
  return authHooks.createUserProfile(user);
});

exports.onUserDelete = functions.auth.user().onDelete((user) => {
  return authHooks.deleteUserProfile(user.uid);
});

exports.onFirestoreWrite = functions.firestore
  .document('{collectionId}/{docId}')
  .onWrite((change, context) => {
    console.log(`Document ${context.params.docId} in collection ${context.params.collectionId} was written.`);
  });
