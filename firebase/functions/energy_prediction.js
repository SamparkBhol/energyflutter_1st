const admin = require('firebase-admin');
const tf = require('@tensorflow/tfjs-node'); // TensorFlow.js for ML in Node.js
const path = require('path');

// Mock prediction model (this should be a real trained model in production)
const modelPath = path.resolve(__dirname, 'models', 'energy_model.json');
let model;

const loadModel = async () => {
  if (!model) {
    model = await tf.loadLayersModel(`file://${modelPath}`);
  }
  return model;
};

exports.predictUsage = async (userId) => {
  const userRef = admin.firestore().collection('users').doc(userId);
  const usageData = await userRef.collection('usage').orderBy('time', 'desc').limit(1).get();

  if (usageData.empty) {
    console.log('No usage data found for user:', userId);
    return;
  }

  const recentUsage = usageData.docs[0].data().usage;
  const inputTensor = tf.tensor2d([recentUsage], [1, 1]);

  const model = await loadModel();
  const prediction = model.predict(inputTensor).dataSync()[0];

  await userRef.collection('predictions').add({
    date: new Date().toISOString(),
    predictedUsage: prediction,
  });

  console.log(`Predicted energy usage for user ${userId}: ${prediction}`);
  return prediction;
};
