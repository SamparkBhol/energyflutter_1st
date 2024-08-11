const admin = require('firebase-admin');

exports.createUserProfile = async (user) => {
  const userRef = admin.firestore().collection('users').doc(user.uid);

  const newUser = {
    uid: user.uid,
    email: user.email,
    name: user.displayName || '',
    avatarUrl: user.photoURL || '',
    createdAt: new Date().toISOString(),
  };

  await userRef.set(newUser);
  console.log(`User profile created for UID: ${user.uid}`);
};

exports.deleteUserProfile = async (userId) => {
  const userRef = admin.firestore().collection('users').doc(userId);

  await userRef.delete();
  console.log(`User profile deleted for UID: ${userId}`);
};
